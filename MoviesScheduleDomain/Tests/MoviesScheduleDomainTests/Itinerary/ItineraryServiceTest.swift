//
//  ItineraryServiceTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct ItineraryServiceTest {
    
    actor MovieRepositoryMock: MovieRepository {
        
        private var movies: [Movie] = []
        
        func setMovies(_ movies: [Movie]) {
            self.movies = movies
        }
        
        func getAll() async throws(RetrieveError) -> [Movie] {
            return movies
        }
        
        func get(byIds ids: [Int64]) async throws(RetrieveError) -> [Movie] {
            return movies.filter { ids.contains($0.id) }
        }
    }
    
    actor TheaterRepositoryMock: TheaterRepository {

        private var theaters: [Theater] = []
        
        func setTheaters(_ theaters: [Theater]) {
            self.theaters = theaters
        }
        
        func get(byMovieIds movieIds: [Int64]) async throws(RetrieveError) -> [Theater] {
            return []
        }
        
        func get(byIds ids: [Int64]) async throws(RetrieveError) -> [Theater] {
            return theaters.filter { ids.contains($0.id) }
        }
    }
    
    private let itineraryService: ItineraryServiceImpl
    private let movieRepository: MovieRepositoryMock
    private let theaterRepository: TheaterRepositoryMock

    init() {
        movieRepository = MovieRepositoryMock()
        theaterRepository = TheaterRepositoryMock()
        itineraryService = ItineraryServiceImpl(movieRepository: movieRepository, theaterRepository: theaterRepository)
    }
    
    @Test func shouldCreateItineraryWithMovieItemsOnly() async throws {
        // given:
        await movieRepository.setMovies([
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 2, title: "Mad Max", duration: 120),
            Movie(id: 3, title: "The Godfather", duration: 180),
        ])
        await theaterRepository.setTheaters([
            Theater(id: 10, name: "AMC"),
            Theater(id: 20, name: "Cinemark")
        ])
        let userSchedule = UserSchedule(items: [
            UserScheduleItem(movieId: 1, theaterId: 10, schedule: "14:30"),
            UserScheduleItem(movieId: 2, theaterId: 20, schedule: "21:00"),
            UserScheduleItem(movieId: 3, theaterId: 10, schedule: "17:30")
        ])
        
        // when:
        let itineraryItems = await itineraryService.createItineraryWithMovieItemsOnly(fromUserSchedule: userSchedule)
        
        // then:
        #expect(itineraryItems == [
            ItineraryItem(
                startAt: "14:30",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 1, title: "Star Wars", duration: 120),
                    theater: Theater(id: 10, name: "AMC")
                )
            ),
            ItineraryItem(
                startAt: "17:30",
                duration: 180,
                itineraryItemType: .movie(
                    movie: Movie(id: 3, title: "The Godfather", duration: 180),
                    theater: Theater(id: 10, name: "AMC")
                )
            ),
            ItineraryItem(
                startAt: "21:00",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 2, title: "Mad Max", duration: 120),
                    theater: Theater(id: 20, name: "Cinemark")
                )
            ),
        ])
    }

}
