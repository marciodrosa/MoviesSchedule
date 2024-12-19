//
//  Itinerary.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

/** Representation of a user schedule formatted as a series of sorted itinerary items.  */
public struct Itinerary: Equatable, Sendable {
    public let items: [ItineraryItem]
    
    public init(items: [ItineraryItem]) {
        self.items = items
    }
}
