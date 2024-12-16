//
//  TheaterRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

@MainActor
public protocol TheaterRepository {
    func get(byMovieIds: [Int64]) async throws(RetrieveError) -> [Theater]
    func get(byIds: [Int64]) async throws(RetrieveError) -> [Theater]
}
