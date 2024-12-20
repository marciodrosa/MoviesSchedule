//
//  MovieFromFileRepository.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 03/12/24.
//

import Foundation
import MoviesScheduleDomain

struct MovieFromFileRepository: MovieRepository {
    
    let jsonResourceFileLoader: JsonResourceFileLoader
    
    init(jsonResourceFileLoader: JsonResourceFileLoader) {
        self.jsonResourceFileLoader = jsonResourceFileLoader
    }
    
    func getAll() async throws((CrudError)) -> [Movie] {
        return try await jsonResourceFileLoader.load()
    }
    
    func get(byIds ids: [Int64]) async throws((CrudError)) -> [Movie] {
        return try await jsonResourceFileLoader.load().filter { ids.contains($0.id) }
    }
}
