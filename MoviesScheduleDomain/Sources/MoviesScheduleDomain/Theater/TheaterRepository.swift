//
//  TheaterRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public protocol TheaterRepository: Sendable {
    func get(byMovieIds: [Int64]) async throws(RetrieveError) -> [Theater]
}
