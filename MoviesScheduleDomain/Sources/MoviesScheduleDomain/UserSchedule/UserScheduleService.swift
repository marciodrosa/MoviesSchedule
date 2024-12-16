//
//  UserScheduleService.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 11/12/24.
//

import Foundation

@MainActor
public protocol UserScheduleService {
    func getItemsData(_ userSchedule: UserSchedule) async -> [UserScheduleItemData]
}

struct UserScheduleServiceImpl: UserScheduleService {
    
    private let movieRepository: MovieRepository
    private let theaterRepository: TheaterRepository
    
    init(movieRepository: MovieRepository, theaterRepository: TheaterRepository) {
        self.movieRepository = movieRepository
        self.theaterRepository = theaterRepository
    }
    
    public func getItemsData(_ userSchedule: UserSchedule) async -> [UserScheduleItemData] {
        let movieIds = userSchedule.items.map { $0.movieId }
        let theaterIds = userSchedule.items.map { $0.theaterId }
        let movies = (try? await movieRepository.get(byIds: movieIds)) ?? []
        let theaters = (try? await theaterRepository.get(byIds: theaterIds)) ?? []
        return userSchedule.items.compactMap { scheduleItem in
            guard let movie = movies.first(where: { m in m.id == scheduleItem.movieId }) else {
                return nil
            }
            guard let theater = theaters.first(where: { t in t.id == scheduleItem.theaterId }) else {
                return nil
            }
            return UserScheduleItemData(movie: movie, theater: theater, schedule: scheduleItem.schedule)
        }
    }
    
    private func calculateEndTime(withSchedule schedule: String, movie: Movie) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        guard let scheduleDate = dateFormatter.date(from: schedule) else {
            return nil
        }
        let endDate = scheduleDate.addingTimeInterval(Double(movie.duration) * 60)
        return dateFormatter.string(from: endDate)
    }
}
