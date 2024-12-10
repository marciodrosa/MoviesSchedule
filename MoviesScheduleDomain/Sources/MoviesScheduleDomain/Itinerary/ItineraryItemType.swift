//
//  ItineraryItemType.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

public enum ItineraryItemType: Equatable {
    case movie(movie: Movie, theater: Theater, conflicts: [ItineraryConflict] = [])
    case interval(newTheater: Theater? = nil)
}
