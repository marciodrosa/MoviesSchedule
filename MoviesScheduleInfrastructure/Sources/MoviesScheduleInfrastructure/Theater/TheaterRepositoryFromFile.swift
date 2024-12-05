//
//  TheaterRepositoryFromFile.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation
import MoviesScheduleDomain

actor TheaterRepositoryFromFile: TheaterRepository {
    
    let jsonResourceFileLoader: JsonResourceFileLoader
    
    init(jsonResourceFileLoader: JsonResourceFileLoader) {
        self.jsonResourceFileLoader = jsonResourceFileLoader
    }
    
    func get(byIds ids: [Int64]) async throws(RetrieveError) -> [Theater] {
        let allTheaters: [Theater] = try await jsonResourceFileLoader.load()
        return allTheaters.filter { ids.contains($0.id) }
    }
}
