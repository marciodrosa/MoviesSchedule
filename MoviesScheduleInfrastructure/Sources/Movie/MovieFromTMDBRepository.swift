//
//  MovieFromTMDBRepository.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 03/12/24.
//

import Foundation
import MoviesScheduleDomain
import TMDBClient

struct MovieFromTMDBRepository: MovieRepository {
    
    let tmdbClient: TMDBClient.ApiClient
    
    init(tmdbClient: TMDBClient.ApiClient) {
        self.tmdbClient = tmdbClient
    }
    
    func getAll() async throws((CrudError)) -> [Movie] {
        return []
    }
    
    func get(byIds ids: [Int64]) async throws((CrudError)) -> [Movie] {
        var result: [Movie] = []
        for id in ids {
            do {
                if let movieDetails = try await tmdbClient.getMovieDetails(id: id) {
                    result.append(Movie(withTMDBMovieDetails: movieDetails))
                }
            } catch {
                throw .from(tmdbError: error)
            }
        }
        return result
    }
}
