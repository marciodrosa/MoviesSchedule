//
//  UserScheduleItem.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 06/12/24.
//

public struct UserScheduleItem: Equatable, Sendable {
    let movieId: Int64
    let theaterId: Int64
    let schedule: String
}
