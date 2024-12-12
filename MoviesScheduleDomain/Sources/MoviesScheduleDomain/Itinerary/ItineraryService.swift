//
//  ItineraryService.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

public protocol ItineraryService: Sendable {
    func createItinerary() async -> Itinerary
}

struct ItineraryServiceImpl: ItineraryService {
    
    private let userScheduleRepository: UserScheduleRepository
    private let userScheduleService: UserScheduleService
    
    init(userScheduleRepository: UserScheduleRepository, userScheduleService: UserScheduleService) {
        self.userScheduleRepository = userScheduleRepository
        self.userScheduleService = userScheduleService
    }
    
    public func createItinerary() async -> Itinerary {
        guard let userSchedule = try? await userScheduleRepository.get() else {
            return Itinerary(items: [])
        }
        let selectedScheduleData = await userScheduleService.getItemsData(userSchedule).sorted { $0.schedule < $1.schedule }
        var itineraryItems: [ItineraryItem] = []
        for i in 0..<selectedScheduleData.count {
            let current = selectedScheduleData[i]
            let conflicts = findConflicts(current, others: selectedScheduleData)
            if conflicts.isEmpty {
                itineraryItems.append(.movie(movie: current.movie, theater: current.theater, schedule: current.schedule))
            } else {
                itineraryItems.append(.movieWithConflicts(movie: current.movie, theater: current.theater, schedule: current.schedule, conflicts: conflicts))
            }
            if let next = i < selectedScheduleData.count - 1 ? selectedScheduleData[i + 1] : nil {
                if current.isEndOfMovieInConflictWithOthers(selectedScheduleData) {
                    continue
                }
                if let intervalItem = createIntervalItem(betweenItem: current, andItem: next) {
                    itineraryItems.append(intervalItem)
                }
            }
        }
        return Itinerary(items: itineraryItems)
    }
    
    func createIntervalItem(betweenItem item: UserScheduleItemData, andItem nextItem: UserScheduleItemData) -> ItineraryItem? {
        let timeToNextItem = calculateIntervalDuration(endTime: item.endsAt, nextStartTime: nextItem.schedule)
        if timeToNextItem < 0 {
            return nil
        }
        let willChangeTheater = nextItem.theater != item.theater
        if willChangeTheater {
            if timeToNextItem == 0 {
                return .goToOtherTheaterWithoutTime(theater: nextItem.theater)
            } else {
                return .goToOtherTheater(availableTime: timeToNextItem, theater: nextItem.theater)
            }
        } else {
            if timeToNextItem == 0 {
                return .noInterval
            } else {
                return .interval(duration: timeToNextItem)
            }
        }
    }
    
    func findConflicts(_ selection: UserScheduleItemData, others: [UserScheduleItemData]) -> [ItineraryConflict] {
        return others.compactMap { other in
            guard other != selection else {
                return nil
            }
            if selection.schedule == other.schedule {
                return ItineraryConflict.sameStartTime(movie: other.movie, theater: other.theater)
            } else if other.schedule > selection.schedule && other.schedule < selection.endsAt {
                return ItineraryConflict.endTimeAfterOtherMovieStarted(movie: other.movie, theater: other.theater, conflictDuration: calculateConflictDuration(startTime1: selection.schedule, endTime1: selection.endsAt, startTime2: other.schedule, endTime2: other.endsAt))
            } else if selection.schedule > other.schedule && selection.schedule < other.endsAt {
                return ItineraryConflict.startTimeBeforeOtherMovieEnded(movie: other.movie, theater: other.theater, conflictDuration: calculateConflictDuration(startTime1: selection.schedule, endTime1: selection.endsAt, startTime2: other.schedule, endTime2: other.endsAt))
            } else {
                return nil
            }
        }
    }
    
    private func calculateConflictDuration(startTime1: String, endTime1: String, startTime2: String, endTime2: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let startAtDate = dateFormatter.date(from: max(startTime1, startTime2))
        let endsAtDate = dateFormatter.date(from: min(endTime1, endTime2))
        if let startAtDate, let endsAtDate {
            return Int(endsAtDate.timeIntervalSince(startAtDate) / 60)
        }
        return 0
    }
    
    private func calculateIntervalDuration(endTime: String, nextStartTime: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let endsAtDate = dateFormatter.date(from: endTime)
        let nextStartDate = dateFormatter.date(from: nextStartTime)
        if let endsAtDate, let nextStartDate {
            return Int(nextStartDate.timeIntervalSince(endsAtDate) / 60)
        }
        return 0
    }
}
