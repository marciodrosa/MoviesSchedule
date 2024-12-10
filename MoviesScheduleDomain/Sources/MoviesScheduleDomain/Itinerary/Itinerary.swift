//
//  Itinerary.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

/** Representation of a user schedule formatted as a series of sorted itinerary items with start and end dates.  */
public struct Itinerary: Equatable {
    let items: [ItineraryItem]
    
    public init(items: [ItineraryItem]) {
        self.items = items
    }
}
