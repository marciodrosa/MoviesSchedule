//
//  Itinerary.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

public struct Itinerary {
    let items: [ItineraryItem]
    
    public init(items: [ItineraryItem]) {
        self.items = items
    }
    
    public init(userSchedule: UserSchedule) {
        var itineraryItems: [ItineraryItem] = []
        let userScheduleItems = userSchedule.items.sorted { $0.schedule < $1.schedule }
        
        
        
        self.items = itineraryItems
    }
}
