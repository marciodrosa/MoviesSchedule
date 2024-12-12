//
//  ItineraryItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

/** Element of an itinerary with start and end times that could represent things like a scheduled selected movie or an interval between movies. */
public enum ItineraryItem: Equatable, Sendable {
    case movie(movie: Movie, theater: Theater, schedule: String)
    case movieWithConflicts(movie: Movie, theater: Theater, schedule: String, conflicts: [ItineraryConflict])
    case interval(duration: Int)
    case noInterval
    case goToOtherTheater(availableTime: Int, theater: Theater)
    case goToOtherTheaterWithoutTime(theater: Theater)
    
    var movie: Movie? {
        switch self {
        case .movie(movie: let movie, _, _):
            movie
        case .movieWithConflicts(movie: let movie, _, _, _):
            movie
        case .interval(_), .noInterval, .goToOtherTheater(_, _), .goToOtherTheaterWithoutTime(_):
            nil
        }
    }
    
    var theater: Theater? {
        switch self {
        case .movie(_, theater: let theater, _):
            theater
        case .movieWithConflicts(_, theater: let theater, _, _):
            theater
        case .interval(_), .noInterval:
            nil
        case .goToOtherTheater(_, theater: let theater):
            theater
        case .goToOtherTheaterWithoutTime(theater: let theater):
            theater
        }
    }
    
    var duration: Int {
        switch self {
        case .movie(movie: let movie, theater: let theater, schedule: let schedule):
            movie.duration
        case .movieWithConflicts(movie: let movie, theater: let theater, schedule: let schedule, conflicts: let conflicts):
            movie.duration
        case .interval(duration: let duration):
            duration
        case .noInterval:
            0
        case .goToOtherTheater(availableTime: let availableTime, theater: let theater):
            availableTime
        case .goToOtherTheaterWithoutTime(theater: let theater):
            0
        }
    }
}
