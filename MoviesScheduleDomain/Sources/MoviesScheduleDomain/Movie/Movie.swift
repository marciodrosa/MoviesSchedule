//
//  Movie.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

import Foundation;

public struct Movie: Equatable, Sendable, Decodable, Identifiable {
    public let id: Int64
    public let title: String
    public let duration: Int
    
    public init(id: Int64, title: String, duration: Int) {
        self.id = id
        self.title = title
        self.duration = duration
    }
    
    public func endsAt(whenStartingAt schedule: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        guard let scheduleDate = dateFormatter.date(from: schedule) else {
            return "00:00"
        }
        let endDate = scheduleDate.addingTimeInterval(Double(duration) * 60)
        return dateFormatter.string(from: endDate)
    }
}
