//
//  MovieRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public protocol MovieRepository: Sendable {
    func getAll() async throws(RetrieveError) -> [Movie]
    func get(byIds: [Int64]) async throws(RetrieveError) -> [Movie]
}
