//
//  UserScheduleItemData.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 11/12/24.
//

import Foundation

/** Value object containing data regarding a selected schedule. */
public struct UserScheduleItemData: Equatable, Sendable {
    public let movie: Movie
    public let theater: Theater
    public let schedule: String
    
    public var endsAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        guard let scheduleDate = dateFormatter.date(from: schedule) else {
            return schedule
        }
        let endDate = scheduleDate.addingTimeInterval(Double(movie.duration) * 60)
        return dateFormatter.string(from: endDate)
    }
    
    init(movie: Movie, theater: Theater, schedule: String) {
        self.movie = movie
        self.theater = theater
        self.schedule = schedule
    }
    
    public func isEndOfMovieInConflictWithOthers(_ others: [UserScheduleItemData]) -> Bool {
        return others.contains { other in
            guard other != self else {
                return false
            }
            return endsAt < other.endsAt && other.schedule < endsAt
        }
    }
}
