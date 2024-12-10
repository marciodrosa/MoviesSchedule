//
//  ItineraryConflict.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 10/12/24.
//

public enum ItineraryConflict: Equatable {
    case sameStartTime(movie: Movie, theater: Theater)
    case startTimeBeforeOtherMovieEnded(movie: Movie, theater: Theater, conflictDuration: Int)
    case endTimeAfterOtherMovieStarted(movie: Movie, theater: Theater, conflictDuration: Int)
}
