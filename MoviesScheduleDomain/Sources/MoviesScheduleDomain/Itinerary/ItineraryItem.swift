//
//  ItineraryItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Foundation

/** Element of an itinerary with start and end times that could represent things like a scheduled selected movie or an interval between movies. */
public struct ItineraryItem: Equatable {
    let startAt: String
    let endAt: String
    let duration: Int
    let itineraryItemType: ItineraryItemType
    
    public init(startAt: String, endAt: String, itineraryItemType: ItineraryItemType) {
        self.startAt = startAt
        self.endAt = endAt
        self.itineraryItemType = itineraryItemType
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let startDate = dateFormatter.date(from: startAt)
        let endDate = dateFormatter.date(from: endAt)
        if let startDate, let endDate {
            duration = Int(endDate.timeIntervalSince(startDate) / 60)
        } else {
            duration = 0
        }
    }
    
    public init(startAt: String, duration: Int, itineraryItemType: ItineraryItemType) {
        self.startAt = startAt
        self.duration = duration
        self.itineraryItemType = itineraryItemType
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let startAtDate = dateFormatter.date(from: startAt)
        if let startAtDate {
            endAt = dateFormatter.string(from: startAtDate.addingTimeInterval(Double(duration) * 60))
        } else {
            endAt = startAt
        }
    }
    
    func withNewItineraryItemType(_ newItineraryItemType: ItineraryItemType) -> ItineraryItem {
        ItineraryItem(startAt: startAt, endAt: endAt, itineraryItemType: newItineraryItemType)
    }
}
