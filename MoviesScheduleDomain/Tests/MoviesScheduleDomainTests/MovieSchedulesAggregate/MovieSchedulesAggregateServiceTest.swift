//
//  MovieSchedulesAggregateServiceTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 29/11/24.
//

import Testing
import Foundation
@testable import MoviesScheduleDomain

struct MovieSchedulesAggregateServiceTest {
    
    class MovieRepositoryMock: MovieRepository {
        
        var movies: [Movie] = []
        
        func getAll() async -> [Movie] {
            return movies
        }
    }
    
    class MovieSchedulesRepositoryMock: MovieSchedulesRepository {
        
        var movieSchedules: [MovieSchedules] = []
        
        func get(byMovieId movieId: Int64) async -> [MovieSchedules] {
            return movieSchedules.filter { $0.movieId == movieId }
        }
    }
    
    class TheaterRepositoryMock: TheaterRepository {
        
        var theaters: [Theater] = []
        
        func get(byIds ids: [Int64]) async -> [Theater] {
            return theaters.filter { ids.contains($0.id) }
        }
    }
    
    let service: MovieSchedulesAggregateService
    let movieRepository = MovieRepositoryMock()
    let movieSchedulesRepository = MovieSchedulesRepositoryMock()
    let theaterRepository = TheaterRepositoryMock()
    
    init() {
        service = MovieSchedulesAggregateServiceImpl(movieRepository: movieRepository, movieSchedulesRepository: movieSchedulesRepository, theaterRepository: theaterRepository)
    }

    @Test mutating func shouldReturnAllMoviesSchedules() async throws {
        // given:
        movieRepository.movies = [
            Movie(id: 1, title: "Star Wars", duration: TimeInterval(120)),
            Movie(id: 2, title: "The Godfather", duration: TimeInterval(180)),
        ]
        theaterRepository.theaters = [
            Theater(id: 10, name: "AMC"),
            Theater(id: 20, name: "Cinemark"),
        ]
        movieSchedulesRepository.movieSchedules = [
            MovieSchedules(movieId: 1, theaterId: 10, schedules: ["15:00", "17:30"]),
            MovieSchedules(movieId: 1, theaterId: 20, schedules: ["21:00"]),
            MovieSchedules(movieId: 2, theaterId: 20, schedules: ["18:00"]),
        ]
        
        // when:
        let result = await service.getAllMovieSchedules()
        
        // then:
        #expect(result == [
            MovieSchedulesAggregate(
                movie: Movie(id: 1, title: "Star Wars", duration: TimeInterval(120)),
                movieSchedules: [
                    MovieSchedules(movieId: 1, theaterId: 10, schedules: ["15:00", "17:30"]),
                    MovieSchedules(movieId: 1, theaterId: 20, schedules: ["21:00"])
                ],
                theaters: [
                    Theater(id: 10, name: "AMC"),
                    Theater(id: 20, name: "Cinemark")
                ]
            ),
            MovieSchedulesAggregate(
                movie: Movie(id: 2, title: "The Godfather", duration: TimeInterval(180)),
                movieSchedules: [
                    MovieSchedules(movieId: 2, theaterId: 20, schedules: ["18:00"])
                ],
                theaters: [
                    Theater(id: 20, name: "Cinemark")
                ]
            ),
        ])
    }
}
