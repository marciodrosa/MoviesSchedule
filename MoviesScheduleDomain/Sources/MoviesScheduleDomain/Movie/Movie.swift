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
    public let duration: TimeInterval
    
    public init(id: Int64, title: String, duration: TimeInterval) {
        self.id = id
        self.title = title
        self.duration = duration
    }
}
