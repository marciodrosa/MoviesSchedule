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
    
    actor MovieRepositoryMock: MovieRepository {
        
        var movies: [Movie] = []
        
        func setMovies(_ movies: [Movie]) {
            self.movies = movies
        }
        
        func getAll() async -> [Movie] {
            return movies
        }
    }
    
    actor MovieSchedulesRepositoryMock: MovieSchedulesRepository {
        
        var movieSchedules: [MovieSchedules] = []
        
        func setMovieSchedules(_ movieSchedules: [MovieSchedules]) {
            self.movieSchedules = movieSchedules
        }
        
        func get(byMovieId movieId: Int64) async -> [MovieSchedules] {
            return movieSchedules.filter { $0.movieId == movieId }
        }
    }
    
    actor TheaterRepositoryMock: TheaterRepository {
        
        var theaters: [Theater] = []
        
        func setTheaters(_ theaters: [Theater]) {
            self.theaters = theaters
        }
        
        func get(byIds ids: [Int64]) async -> [Theater] {
            return theaters.filter { ids.contains($0.id) }
        }
    }
    
    actor UserSelectionRepositoryMock: UserSelectionRepository {
        
        var userSelections: [UserSelection] = []
        
        func setUserSelection(_ userSelections: [UserSelection]) {
            self.userSelections = userSelections
        }
        
        func get(byMovieId movieId: Int64) async -> [UserSelection] {
            return userSelections.filter { $0.movieId == movieId }
        }
    }
    
    let service: MovieSchedulesAggregateService
    let movieRepository = MovieRepositoryMock()
    let movieSchedulesRepository = MovieSchedulesRepositoryMock()
    let theaterRepository = TheaterRepositoryMock()
    let userSelectionRepository = UserSelectionRepositoryMock()
    
    init() {
        service = MovieSchedulesAggregateServiceImpl(movieRepository: movieRepository, movieSchedulesRepository: movieSchedulesRepository, theaterRepository: theaterRepository, userSelectionRepository: userSelectionRepository)
    }

    @Test mutating func shouldReturnAllMoviesSchedules() async throws {
        // given:
        await movieRepository.setMovies([
            Movie(id: 1, title: "Star Wars", duration: TimeInterval(120)),
            Movie(id: 2, title: "The Godfather", duration: TimeInterval(180)),
        ])
        await theaterRepository.setTheaters([
            Theater(id: 10, name: "AMC"),
            Theater(id: 20, name: "Cinemark"),
        ])
        await movieSchedulesRepository.setMovieSchedules([
            MovieSchedules(movieId: 1, theaterId: 10, schedules: ["15:00", "17:30"]),
            MovieSchedules(movieId: 1, theaterId: 20, schedules: ["21:00"]),
            MovieSchedules(movieId: 2, theaterId: 20, schedules: ["18:00"]),
        ])
        await userSelectionRepository.setUserSelection([
            UserSelection(movieId: 1, theaterId: 10, schedule: "17:30"),
            UserSelection(movieId: 2, theaterId: 20, schedule: "18:00"),
        ])
        
        // when:
        let result = try! await service.getAllMovieSchedules()
        
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
                ],
                userSelections: [
                    UserSelection(movieId: 1, theaterId: 10, schedule: "17:30"),
                ]
            ),
            MovieSchedulesAggregate(
                movie: Movie(id: 2, title: "The Godfather", duration: TimeInterval(180)),
                movieSchedules: [
                    MovieSchedules(movieId: 2, theaterId: 20, schedules: ["18:00"])
                ],
                theaters: [
                    Theater(id: 20, name: "Cinemark")
                ],
                userSelections: [
                    UserSelection(movieId: 2, theaterId: 20, schedule: "18:00"),
                ]
            ),
        ])
    }
}
