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
    
    func get(byMovieIds movieIds: [Int64]) async throws(RetrieveError) -> [Theater] {
        let allTheaters: [Theater] = try await jsonResourceFileLoader.load()
        let allSchedules: [MovieSchedules] = try await jsonResourceFileLoader.load()
        let movieSchedules = allSchedules.filter { movieIds.contains($0.movieId) }
        let theaterIds = movieSchedules.map { $0.theaterId }
        return allTheaters
            .filter { theaterIds.contains($0.id) }
            .map { theater in
                var theaterWithSchedules = theater
                theaterWithSchedules.movieSchedules = movieSchedules.filter { $0.theaterId == theater.id }
                return theaterWithSchedules
            }
    }
}
