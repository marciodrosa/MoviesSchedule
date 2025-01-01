//
//  UserScheduleServiceTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 11/12/24.
//

import Testing
@testable import MoviesScheduleDomain

@MainActor
struct UserScheduleServiceTest {
    
    class MovieRepositoryMock: MovieRepository {
        
        var movies: [Movie] = []
        
        func getAll() async throws(CrudError) -> [Movie] {
            return movies
        }
        
        func get(byIds ids: [Int64]) async throws(CrudError) -> [Movie] {
            return movies.filter { ids.contains($0.id) }
        }
    }
    
    class TheaterRepositoryMock: TheaterRepository {
        
        var theaters: [Theater] = []
        
        func get(byMovieIds movieIds: [Int64]) async throws(CrudError) -> [Theater] {
            return []
        }
        
        func get(byIds ids: [Int64]) async throws(CrudError) -> [Theater] {
            return theaters.filter { ids.contains($0.id) }
        }
        
        func getAll() async throws(MoviesScheduleDomain.CrudError) -> [MoviesScheduleDomain.Theater] {
            return theaters
        }
    }
    
    private let userScheduleService: UserScheduleServiceImpl
    private let movieRepository: MovieRepositoryMock
    private let theaterRepository: TheaterRepositoryMock

    init() {
        movieRepository = MovieRepositoryMock()
        theaterRepository = TheaterRepositoryMock()
        userScheduleService = UserScheduleServiceImpl(movieRepository: movieRepository, theaterRepository: theaterRepository)
    }
    
    @Test func shouldReturnItemsData() async throws {
        // given:
        movieRepository.movies = [
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 2, title: "Mad Max", duration: 90),
            Movie(id: 3, title: "The Godfather", duration: 180),
        ]
        theaterRepository.theaters = [
            Theater(id: 10, name: "AMC"),
            Theater(id: 20, name: "Cinemark"),
        ]
        let userSchedule = UserSchedule(items: [
            UserScheduleItem(movieId: 1, theaterId: 10, schedule: "14:30"),
            UserScheduleItem(movieId: 2, theaterId: 10, schedule: "17:00"),
            UserScheduleItem(movieId: 3, theaterId: 20, schedule: "20:00"),
        ])
        
        // when:
        let result = await userScheduleService.getItemsData(userSchedule)
        
        // then:
        #expect(result == [
            UserScheduleItemData(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30"
            ),
            UserScheduleItemData(
                movie: Movie(id: 2, title: "Mad Max", duration: 90),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "17:00"
            ),
            UserScheduleItemData(
                movie: Movie(id: 3, title: "The Godfather", duration: 180),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "20:00"
            ),
        ])
    }
}
