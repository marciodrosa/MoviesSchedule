//
//  ItineraryConflict.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 10/12/24.
//

/** Types of conflicts an itinerary item can have, like movies playing at the same time. */
public enum ItineraryConflict: Equatable, Sendable {
    case sameStartTime(movie: Movie, theater: Theater)
    case startTimeBeforeOtherMovieEnded(movie: Movie, theater: Theater, conflictDuration: Int)
    case endTimeAfterOtherMovieStarted(movie: Movie, theater: Theater, conflictDuration: Int)
}
