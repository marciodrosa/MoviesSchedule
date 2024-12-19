//
//  UserScheduleItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 06/12/24.
//

/** Entity that represents a single schedule selected by the user. */
public struct UserScheduleItem: Equatable, Sendable {
    public let movieId: Int64
    public let theaterId: Int64
    public let schedule: String
    
    public init(movieId: Int64, theaterId: Int64, schedule: String) {
        self.movieId = movieId
        self.theaterId = theaterId
        self.schedule = schedule
    }
}
