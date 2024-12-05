//
//  UserSelection.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

public struct UserSelection: Equatable, Sendable {
    let movieId: Int64
    let theaterId: Int64
    let schedule: String
}
