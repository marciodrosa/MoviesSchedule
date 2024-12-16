//
//  MovieRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

@MainActor
public protocol MovieRepository {
    func getAll() async throws(RetrieveError) -> [Movie]
    func get(byIds: [Int64]) async throws(RetrieveError) -> [Movie]
}
