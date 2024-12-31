//
//  MovieFromTMDBRepositoryTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain
import TMDBClient

@MainActor
struct MovieFromTMDBRepositoryTest {
    
    static let mockedData = [
        TMDBClient.MovieDetails(id: 10, runtime: 94, title: "The Jigsaw Man"),
        TMDBClient.MovieDetails(id: 20, runtime: 116, title: "The Bikeriders"),
        TMDBClient.MovieDetails(id: 30, runtime: 148, title: "Gladiator II"),
    ]
    
    struct TMDBApiClientMock: TMDBClient.ApiClient {
        func getMovieDetails(id: Int64) async throws(TMDBClient.ApiError) -> TMDBClient.MovieDetails? {
            return mockedData.first { $0.id == id }
        }
    }
    
    let repository: MovieFromTMDBRepository
    
    init() {
        repository = MovieFromTMDBRepository(tmdbClient: TMDBApiClientMock())
    }

    @Test func shouldGetAllMoviesFromJsonFile() async throws {
        // when:
        let result = try! await repository.get(byIds: [10, 15, 30])
        
        // then:
        #expect(result.count == 2)
        #expect(result.contains(Movie(id: 10, title: "The Jigsaw Man", duration: 94)))
        #expect(result.contains(Movie(id: 30, title: "Gladiator II", duration: 148)))
    }
}
