//
//  MovieRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

protocol MovieRepository {
    func getAll() async -> [Movie]
}
