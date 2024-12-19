//
//  TheaterRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

/** Repository for the theater entity. */
@MainActor
public protocol TheaterRepository {
    func get(byMovieIds: [Int64]) async throws(CrudError) -> [Theater]
    func get(byIds: [Int64]) async throws(CrudError) -> [Theater]
}
