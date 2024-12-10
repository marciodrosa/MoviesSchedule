//
//  UserScheduleItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 06/12/24.
//

/** Entity that represents a single schedule selected by the user. */
public struct UserScheduleItem: Equatable, Sendable {
    let movieId: Int64
    let theaterId: Int64
    let schedule: String
}
