//
//  MovieSchedules.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

/** The available schedules for a given movie at a given theater. */
public struct MovieSchedules: Equatable, Sendable, Decodable {
    public let movieId: Int64
    public let theaterId: Int64
    public let schedules: [String]
    
    public init(movieId: Int64, theaterId: Int64, schedules: [String]) {
        self.movieId = movieId
        self.theaterId = theaterId
        self.schedules = schedules
    }
}
