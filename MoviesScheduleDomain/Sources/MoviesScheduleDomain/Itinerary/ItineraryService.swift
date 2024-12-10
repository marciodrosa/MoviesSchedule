//
//  ItineraryService.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

public protocol ItineraryService {
    func createItinerary(fromUserSchedule: UserSchedule) async -> Itinerary
}

struct ItineraryServiceImpl: ItineraryService {
    
    private let movieRepository: MovieRepository
    private let theaterRepository: TheaterRepository
    
    init(movieRepository: MovieRepository, theaterRepository: TheaterRepository) {
        self.movieRepository = movieRepository
        self.theaterRepository = theaterRepository
    }
    
    public func createItinerary(fromUserSchedule userSchedule: UserSchedule) async -> Itinerary {
        let movieItems = await createItineraryWithMovieItemsOnly(fromUserSchedule: userSchedule)
        let intervalItems = createIntervalsItems(betweeenItems: movieItems)
        let allItemsSorted = (movieItems + intervalItems).sorted { $0.startAt < $1.startAt }
        return Itinerary(items: allItemsSorted)
    }
    
    func createItineraryWithMovieItemsOnly(fromUserSchedule userSchedule: UserSchedule) async -> [ItineraryItem] {
        let movieIds = userSchedule.items.map { $0.movieId }
        let theaterIds = userSchedule.items.map { $0.theaterId }
        let movies = (try? await movieRepository.get(byIds: movieIds)) ?? []
        let theaters = (try? await theaterRepository.get(byIds: theaterIds)) ?? []
        let scheduleItems = userSchedule.items.sorted { $0.schedule < $1.schedule }
        let itineraryItems: [ItineraryItem] = scheduleItems.compactMap { scheduleItem in
            guard let movie = movies.first(where: { m in m.id == scheduleItem.movieId }) else {
                return nil
            }
            guard let theater = theaters.first(where: { t in t.id == scheduleItem.theaterId }) else {
                return nil
            }
            return ItineraryItem(startAt: scheduleItem.schedule, duration: movie.duration, itineraryItemType: .movie(movie: movie, theater: theater))
        }
        let itineraryItemsWithResolvedConflicts: [ItineraryItem] = itineraryItems.map { item in
            let conflicts = findConflicts(forItem: item, inItems: itineraryItems)
            if conflicts.isEmpty {
                return item
            } else {
                switch item.itineraryItemType {
                case .movie(movie: let movie, theater: let theater, conflicts: _):
                    return ItineraryItem(startAt: item.startAt, duration: item.duration, itineraryItemType: .movie(movie: movie, theater: theater, conflicts: conflicts))
                case .interval(newTheater: _):
                    return item
                }
            }
        }
        return itineraryItemsWithResolvedConflicts
    }
    
    func findConflicts(forItem item: ItineraryItem, inItems items: [ItineraryItem]) -> [ItineraryConflict] {
        switch item.itineraryItemType {
        case .movie(_, _, _):
            return items.compactMap { otherItem in
                guard otherItem != item else {
                    return nil
                }
                if item.startAt == otherItem.startAt {
                    switch otherItem.itineraryItemType {
                    case .movie(let movie, let theater, _):
                        return ItineraryConflict.sameStartTime(movie: movie, theater: theater)
                    case .interval(_):
                        return nil
                    }
                } else if otherItem.startAt > item.startAt && otherItem.startAt < item.endAt {
                    switch otherItem.itineraryItemType {
                    case .movie(let movie, let theater, _):
                        return ItineraryConflict.endTimeAfterOtherMovieStarted(movie: movie, theater: theater, conflictDuration: calculateConflictDuration(item1: item, item2: otherItem))
                    case .interval(_):
                        return nil
                    }
                } else if item.startAt > otherItem.startAt && item.startAt < otherItem.endAt {
                    switch otherItem.itineraryItemType {
                    case .movie(let movie, let theater, _):
                        return ItineraryConflict.startTimeBeforeOtherMovieEnded(movie: movie, theater: theater, conflictDuration: calculateConflictDuration(item1: item, item2: otherItem))
                    case .interval(_):
                        return nil
                    }
                } else {
                    return nil
                }
            }
        case .interval(_):
            return []
        }
    }
    
    private func calculateConflictDuration(item1: ItineraryItem, item2: ItineraryItem) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let startAtDate = dateFormatter.date(from: max(item1.startAt, item2.startAt))
        let endAtDate = dateFormatter.date(from: min(item1.endAt, item2.endAt))
        if let startAtDate, let endAtDate {
            return Int(endAtDate.timeIntervalSince(startAtDate) / 60)
        }
        return 0
    }
    
    func createIntervalsItems(betweeenItems items: [ItineraryItem]) -> [ItineraryItem] {
        var intervalItems: [ItineraryItem] = []
        for item in items {
            switch item.itineraryItemType {
            case .movie(_, let theater, _):
                let endAtIsInConflict = items.contains { $0 != item && $0.startAt < item.endAt && $0.endAt > item.endAt }
                if endAtIsInConflict {
                    continue
                }
                let nextItem = items.first { $0.startAt >= item.endAt }
                if let nextItem {
                    switch nextItem.itineraryItemType {
                    case .movie(_, let nextTheter, _):
                        let changedTheater = theater != nextTheter
                        intervalItems.append(ItineraryItem(startAt: item.endAt, endAt: nextItem.startAt, itineraryItemType: .interval(newTheater: changedTheater ? nextTheter : nil)))
                    case .interval(_):
                        continue
                    }
                }
            case .interval(_):
                continue
            }
        }
        return intervalItems
    }
}
