//
//  Itinerary.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

public struct Itinerary: Equatable {
    let items: [ItineraryItem]
    
    public init(items: [ItineraryItem]) {
        self.items = items
    }
}
