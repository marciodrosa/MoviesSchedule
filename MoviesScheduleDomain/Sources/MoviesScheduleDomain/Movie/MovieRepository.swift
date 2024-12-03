//
//  MovieRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public protocol MovieRepository: Sendable {
    func getAll() async -> [Movie]
}
