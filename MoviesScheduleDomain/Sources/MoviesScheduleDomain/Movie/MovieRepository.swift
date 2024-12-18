//
//  MovieRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

/** The repository for the movie entity. */
@MainActor
public protocol MovieRepository {
    func getAll() async throws(CrudError) -> [Movie]
    func get(byIds: [Int64]) async throws(CrudError) -> [Movie]
}
