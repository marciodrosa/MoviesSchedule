//
//  ItineraryItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

public enum ItineraryItem {
    case movie(movie: Movie, theater: Theater, schedule: String)
    case movieWithSameScheduleConflict(movie: Movie, theater: Theater, schedule: String)
    case movieWithOverlappingScheduleConflict(movie: Movie, theater: Theater, schedule: String, overlappingDuration: Int)
    case interval(timeOfDay: String, duration: Int)
    case goToTheater(timeOfDay: String, duration: Int)
    
    var timeOfDay: String {
        switch self {
        case .movie(movie: _, theater: _, schedule: let schedule):
            schedule
        case .movieWithSameScheduleConflict(movie: _, theater: _, schedule: let schedule):
            schedule
        case .movieWithOverlappingScheduleConflict(movie: _, theater: _, schedule: let schedule, overlappingDuration: _):
            schedule
        case .interval(timeOfDay: let timeOfDay, duration: _):
            timeOfDay
        case .goToTheater(timeOfDay: let timeOfDay, duration: _):
            timeOfDay
        }
    }
    
    var duration: Int {
        switch self {
        case .movie(movie: let movie, theater: _, schedule: _):
            movie.duration
        case .movieWithSameScheduleConflict(movie: let movie, theater: _, schedule: _):
            movie.duration
        case .movieWithOverlappingScheduleConflict(movie: let movie, theater: _, schedule: _, overlappingDuration: _):
            movie.duration
        case .interval(timeOfDay: _, duration: let duration):
            duration
        case .goToTheater(timeOfDay: _, duration: let duration):
            duration
        }
    }
    
    var endTimeOfDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let date = dateFormatter.date(from: timeOfDay)
        guard let date else {
            return "00:00"
        }
        let endingDate = date.addingTimeInterval(Double(duration) * 60)
        return dateFormatter.string(from: endingDate)
    }
}
