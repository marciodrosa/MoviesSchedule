//
//  ItineraryItemType.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

public enum ItineraryItemType: Equatable {
    case movie(movie: Movie, theater: Theater)
    case movieWithSameScheduleConflict(movie: Movie, theater: Theater)
    case movieWithOverlappingScheduleConflict(movie: Movie, theater: Theater)
    case interval
    case intervalWithChangeOfTheater(theater: Theater)
}
