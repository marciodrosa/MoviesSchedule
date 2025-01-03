//
//  TheaterFromFileRepository.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation
import MoviesScheduleDomain

struct TheaterFromFileRepository: TheaterRepository {
    
    let jsonResourceFileLoader: JsonResourceFileLoader
    
    init(jsonResourceFileLoader: JsonResourceFileLoader) {
        self.jsonResourceFileLoader = jsonResourceFileLoader
    }
    
    func get(byMovieIds movieIds: [Int64]) async throws((CrudError)) -> [Theater] {
        let allTheaters: [Theater] = try await jsonResourceFileLoader.load()
        let allSchedules: [MovieSchedules] = try await jsonResourceFileLoader.load()
        let movieSchedules = allSchedules.filter { movieIds.contains($0.movieId) }
        let theaterIds = movieSchedules.map { $0.theaterId }
        return mountAggregate(allTheaters: allTheaters, allSchedules: movieSchedules, filterByIds: theaterIds)
    }
    
    func get(byIds ids: [Int64]) async throws((CrudError)) -> [Theater] {
        let allTheaters: [Theater] = try await jsonResourceFileLoader.load()
        let allSchedules: [MovieSchedules] = try await jsonResourceFileLoader.load()
        return mountAggregate(allTheaters: allTheaters, allSchedules: allSchedules, filterByIds: ids)
    }
    
    func getAll() async throws(MoviesScheduleDomain.CrudError) -> [MoviesScheduleDomain.Theater] {
        let allTheaters: [Theater] = try await jsonResourceFileLoader.load()
        let allSchedules: [MovieSchedules] = try await jsonResourceFileLoader.load()
        return mountAggregate(allTheaters: allTheaters, allSchedules: allSchedules)
    }
    
    private func mountAggregate(allTheaters: [Theater], allSchedules: [MovieSchedules], filterByIds ids: [Int64]? = nil) -> [Theater] {
        return allTheaters
            .filter { ids == nil || ids!.contains($0.id) }
            .map { theater in
                var theaterWithSchedules = theater
                theaterWithSchedules.movieSchedules = allSchedules.filter { $0.theaterId == theater.id }
                return theaterWithSchedules
            }
    }
}
