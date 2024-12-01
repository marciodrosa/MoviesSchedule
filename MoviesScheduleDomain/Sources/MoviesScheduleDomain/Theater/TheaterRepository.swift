//
//  TheaterRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

protocol TheaterRepository {
    func get(byIds: [Int64]) async -> [Theater]
}
