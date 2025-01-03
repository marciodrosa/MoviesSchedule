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
    
    func get(byIds ids: [Int64]) async throws((CrudError)) -> [Movie] {
        do {
            return try await withThrowingTaskGroup(of: Movie?.self) { group in
                for id in ids {
                    group.addTask {
                        if let movieDetails = try await tmdbClient.getMovieDetails(id: id) {
                            return Movie(withTMDBMovieDetails: movieDetails)
                        }
                        return nil
                    }
                }
                var result: [Movie] = []
                for try await movie in group {
                    if let movie {
                        result.append(movie)
                    }
                }
                return result
            }
        } catch let error as TMDBClient.ApiError {
            throw .from(tmdbError: error)
        } catch {
            throw .unknow
        }
    }
}
