//
//  MovieSchedulesRepositoryFromFile.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 03/12/24.
//

import Foundation
import MoviesScheduleDomain

actor MovieSchedulesRepositoryFromFile: MovieSchedulesRepository {
    
    
    let jsonResourceFileLoader: JsonResourceFileLoader
    
    init(jsonResourceFileLoader: JsonResourceFileLoader) {
        self.jsonResourceFileLoader = jsonResourceFileLoader
    }
    
    func get(byMovieId movieId: Int64) async throws(RetrieveError) -> [MovieSchedules] {
        let allMoviesSchedules: [MovieSchedules] = try await jsonResourceFileLoader.load()
        return allMoviesSchedules.filter { $0.movieId == movieId }
    }
}
