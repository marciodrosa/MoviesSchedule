//
//  ScheduleSelectionViewModelTest.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 02/12/24.
//

import Testing
import Foundation
import MoviesScheduleDomain
@testable import MoviesScheduleApplication

@MainActor
class ScheduleSelectionViewModelTest {
    
    class ScheduleSelectionRouterMock: ScheduleSelectionRouter {
        
        var wentToSummary = false
        func goToSummary() {
            wentToSummary = true
        }
    }
    
    actor MovieRepositoryMock: MovieRepository {
        
        private var movies: [Movie] = []
        
        func setMovies(_ movies: [Movie]) {
            self.movies = movies
        }
        
        func getAll() async throws(RetrieveError) -> [Movie] {
            return movies
        }
        
        func get(byIds: [Int64]) async throws(RetrieveError) -> [Movie] {
            return movies
        }
    }
    
    actor TheaterRepositoryMock: TheaterRepository {

        private var theaters: [Theater] = []
        
        func setTheaters(_ theaters: [Theater]) {
            self.theaters = theaters
        }
        
        func get(byMovieIds: [Int64]) async throws(RetrieveError) -> [Theater] {
            return theaters
        }
        
        func get(byIds: [Int64]) async throws(RetrieveError) -> [Theater] {
            return theaters
        }
    }
    
    actor UserScheduleRepositoryMock: UserScheduleRepository {
        
        func get() async throws(RetrieveError) -> UserSchedule? {
            return nil
        }
        
        func save(_ userSchedule: UserSchedule) async throws(CreateError) {
            
        }
    }
    
    let router = ScheduleSelectionRouterMock()
    let movieRepository = MovieRepositoryMock()
    let theaterRepository = TheaterRepositoryMock()
    let userScheduleRepository = UserScheduleRepositoryMock()
    let viewModel: ScheduleSelectionViewModelImpl
    
    init() {
        viewModel = ScheduleSelectionViewModelImpl(router: router, movieRepository: movieRepository, userScheduleRepository: userScheduleRepository, theaterRepository: theaterRepository)
    }

    @Test func shouldLoad() async throws {
        // given:
        await movieRepository.setMovies([
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 2, title: "Mad Max", duration: 120),
            Movie(id: 3, title: "The Godfather", duration: 180),
        ])
        
        await theaterRepository.setTheaters([
            Theater(id: 1, name: "Cinemark", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 1, schedules: ["18:30", "20:30"]),
                MovieSchedules(movieId: 2, theaterId: 1, schedules: ["15:30", "21:30"]),
            ]),
            Theater(id: 2, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 2, schedules: ["17:00"]),
                MovieSchedules(movieId: 3, theaterId: 2, schedules: ["20:00"]),
            ])
        ])

        // when:
        await viewModel.load()

        // then:
        #expect(await viewModel.movies == [
            Movie(id: 2, title: "Mad Max", duration: 120),
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 3, title: "The Godfather", duration: 180),
        ])
        #expect(await viewModel.theaters(byMovie: Movie(id: 1, title: "Star Wars", duration: 120)).count == 2)
        #expect(await viewModel.theaters(byMovie: Movie(id: 2, title: "Mad Max", duration: 120)).count == 1)
        #expect(await viewModel.theaters(byMovie: Movie(id: 3, title: "The Godfather", duration: 180)).count == 1)
        #expect(await !viewModel.loading)
    }
    
    @Test func shouldReturnTheatersByMovieSortedByName() async {
        // given:
        await movieRepository.setMovies([
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 2, title: "Mad Max", duration: 120),
            Movie(id: 3, title: "The Godfather", duration: 180),
        ])
        
        await theaterRepository.setTheaters([
            Theater(id: 1, name: "Cinemark", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 1, schedules: ["18:30", "20:30"]),
                MovieSchedules(movieId: 2, theaterId: 1, schedules: ["15:30", "21:30"]),
            ]),
            Theater(id: 2, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 2, schedules: ["17:00"]),
                MovieSchedules(movieId: 3, theaterId: 2, schedules: ["20:00"]),
            ])
        ])
        await viewModel.load()

        // when:
        let starWarsTheaters = viewModel.theaters(byMovie: Movie(id: 1, title: "Star Wars", duration: 120))
        
        // then:
        #expect(starWarsTheaters == [
            Theater(id: 2, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 2, schedules: ["17:00"]),
                MovieSchedules(movieId: 3, theaterId: 2, schedules: ["20:00"]),
            ]),
            Theater(id: 1, name: "Cinemark", movieSchedules: [
                MovieSchedules(movieId: 1, theaterId: 1, schedules: ["18:30", "20:30"]),
                MovieSchedules(movieId: 2, theaterId: 1, schedules: ["15:30", "21:30"]),
            ]),
        ])
    }
    
    @Test func shouldSelectScheduleInUserSchedule() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        
        //  when:
        viewModel.setScheduleSelected(
            movie: movie,
            theater: theater,
            schedule: "14:30",
            selected: true
        )
        
        // then:
        #expect(viewModel.userSchedule.isItemSelected(movie: movie, theater: theater, schedule: "14:30"))
    }
    
    @Test func shouldUnselectScheduleInUserSchedule() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        viewModel.setScheduleSelected(
            movie: movie,
            theater: theater,
            schedule: "14:30",
            selected: true
        )
        
        //  when:
        viewModel.setScheduleSelected(
            movie: movie,
            theater: theater,
            schedule: "14:30",
            selected: false
        )
        
        // then:
        #expect(!viewModel.userSchedule.isItemSelected(movie: movie, theater: theater, schedule: "14:30"))
    }
    
    @Test func shouldReturnIfScheduleIsSelectedInUserSchedule() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        viewModel.setScheduleSelected(
            movie: movie,
            theater: theater,
            schedule: "14:30",
            selected: true
        )
        
        //  then:
        #expect(viewModel.isScheduleSelected(movie: movie, theater: theater, schedule: "14:30"))
        #expect(!viewModel.isScheduleSelected(movie: movie, theater: theater, schedule: "16:30"))
    }

}
