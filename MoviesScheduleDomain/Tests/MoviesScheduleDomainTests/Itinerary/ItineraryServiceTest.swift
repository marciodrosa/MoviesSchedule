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
    
    actor UserScheduleRepositoryMock: UserScheduleRepository {
        
        private var userSchedule: UserSchedule = UserSchedule(items: [])
        
        func get() async throws(RetrieveError) -> UserSchedule? {
            return userSchedule
        }
        
        func save(_ userSchedule: UserSchedule) async throws(CreateError) {
            self.userSchedule = userSchedule
        }
    }
    
    private let itineraryService: ItineraryServiceImpl
    private let movieRepository: MovieRepositoryMock
    private let theaterRepository: TheaterRepositoryMock
    private let userScheduleRepository: UserScheduleRepositoryMock

    init() {
        movieRepository = MovieRepositoryMock()
        theaterRepository = TheaterRepositoryMock()
        userScheduleRepository = UserScheduleRepositoryMock()
        itineraryService = ItineraryServiceImpl(movieRepository: movieRepository, theaterRepository: theaterRepository, userScheduleRepository: userScheduleRepository)
    }
    
    @Test func shouldCreateItineraryFromUserSchedule() async throws {
        // given:
        await movieRepository.setMovies([
            Movie(id: 1, title: "Star Wars", duration: 120),
            Movie(id: 2, title: "Mad Max", duration: 120),
        ])
        await theaterRepository.setTheaters([
            Theater(id: 10, name: "AMC"),
        ])
        let userSchedule = UserSchedule(items: [
            UserScheduleItem(movieId: 1, theaterId: 10, schedule: "14:30"),
            UserScheduleItem(movieId: 2, theaterId: 10, schedule: "21:00")
        ])
        try await userScheduleRepository.save(userSchedule)
        
        // when:
        let itinerary = await itineraryService.createItinerary()
        
        // then:
        #expect(itinerary.items == [
            ItineraryItem(
                startAt: "14:30",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 1, title: "Star Wars", duration: 120),
                    theater: Theater(id: 10, name: "AMC")
                )
            ),
            ItineraryItem(
                startAt: "16:30",
                endAt: "21:00",
                itineraryItemType: .interval()
            ),
            ItineraryItem(
                startAt: "21:00",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 2, title: "Mad Max", duration: 120),
                    theater: Theater(id: 10, name: "AMC")
                )
            ),
        ])
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
    
    @Test func shouldCreateItineraryWithMovieItemsOnlyWithConflicts() async throws {
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
            UserScheduleItem(movieId: 2, theaterId: 10, schedule: "14:30"),
            UserScheduleItem(movieId: 3, theaterId: 10, schedule: "18:00"),
            UserScheduleItem(movieId: 1, theaterId: 20, schedule: "20:00"),
            UserScheduleItem(movieId: 2, theaterId: 20, schedule: "20:00")
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
                    theater: Theater(id: 10, name: "AMC"),
                    conflicts: [
                        ItineraryConflict.sameStartTime(
                            movie: Movie(id: 2, title: "Mad Max", duration: 120),
                            theater: Theater(id: 10, name: "AMC")
                        )
                    ]
                )
            ),
            ItineraryItem(
                startAt: "14:30",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 2, title: "Mad Max", duration: 120),
                    theater: Theater(id: 10, name: "AMC"),
                    conflicts: [
                        ItineraryConflict.sameStartTime(
                            movie: Movie(id: 1, title: "Star Wars", duration: 120),
                            theater: Theater(id: 10, name: "AMC")
                        )
                    ]
                )
            ),
            ItineraryItem(
                startAt: "18:00",
                duration: 180,
                itineraryItemType: .movie(
                    movie: Movie(id: 3, title: "The Godfather", duration: 180),
                    theater: Theater(id: 10, name: "AMC"),
                    conflicts: [
                        ItineraryConflict.endTimeAfterOtherMovieStarted(
                            movie: Movie(id: 1, title: "Star Wars", duration: 120),
                            theater: Theater(id: 20, name: "Cinemark"),
                            conflictDuration: 60
                        ),
                        ItineraryConflict.endTimeAfterOtherMovieStarted(
                            movie: Movie(id: 2, title: "Mad Max", duration: 120),
                            theater: Theater(id: 20, name: "Cinemark"),
                            conflictDuration: 60
                        )
                    ]
                )
            ),
            ItineraryItem(
                startAt: "20:00",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 1, title: "Star Wars", duration: 120),
                    theater: Theater(id: 20, name: "Cinemark"),
                    conflicts: [
                        ItineraryConflict.startTimeBeforeOtherMovieEnded(
                            movie: Movie(id: 3, title: "The Godfather", duration: 180),
                            theater: Theater(id: 10, name: "AMC"),
                            conflictDuration: 60
                        ),
                        ItineraryConflict.sameStartTime(
                            movie: Movie(id: 2, title: "Mad Max", duration: 120),
                            theater: Theater(id: 20, name: "Cinemark")
                        )
                    ]
                )
            ),
            ItineraryItem(
                startAt: "20:00",
                duration: 120,
                itineraryItemType: .movie(
                    movie: Movie(id: 2, title: "Mad Max", duration: 120),
                    theater: Theater(id: 20, name: "Cinemark"),
                    conflicts: [
                        ItineraryConflict.startTimeBeforeOtherMovieEnded(
                            movie: Movie(id: 3, title: "The Godfather", duration: 180),
                            theater: Theater(id: 10, name: "AMC"),
                            conflictDuration: 60
                        ),
                        ItineraryConflict.sameStartTime(
                            movie: Movie(id: 1, title: "Star Wars", duration: 120),
                            theater: Theater(id: 20, name: "Cinemark")
                        )
                    ]
                )
            ),
        ])
    }
    
    @Test func shouldFindConflicts() throws {
        // given:
        let it1 = ItineraryItem(startAt: "13:00", endAt: "14:30", itineraryItemType: .movie(
            movie: Movie(id: 1, title: "Star Wars", duration: 90), theater: Theater(id: 10, name: "AMC"))
        )
        let it2 = ItineraryItem(startAt: "13:00", endAt: "15:00", itineraryItemType: .movie(
            movie: Movie(id: 2, title: "Mad Max", duration: 120), theater: Theater(id: 10, name: "AMC"))
        )
        let it3 = ItineraryItem(startAt: "12:00", endAt: "13:30", itineraryItemType: .movie(
            movie: Movie(id: 3, title: "Dracula", duration: 90), theater: Theater(id: 20, name: "Cinemark"))
        )
        let it4 = ItineraryItem(startAt: "14:00", endAt: "17:00", itineraryItemType: .movie(
            movie: Movie(id: 4, title: "The Godfather", duration: 180), theater: Theater(id: 20, name: "Cinemark"))
        )
        let it5 = ItineraryItem(startAt: "12:30", endAt: "15:00", itineraryItemType: .movie(
            movie: Movie(id: 5, title: "Batman", duration: 150), theater: Theater(id: 20, name: "Cinemark"))
        )
        let it6 = ItineraryItem(startAt: "13:10", endAt: "13:30", itineraryItemType: .movie(
            movie: Movie(id: 6, title: "Short movie", duration: 10), theater: Theater(id: 20, name: "Cinemark"))
        )
        let it7 = ItineraryItem(startAt: "14:30", endAt: "16:30", itineraryItemType: .movie(
            movie: Movie(id: 7, title: "Jurassic Park", duration: 120), theater: Theater(id: 20, name: "Cinemark"))
        )
        let it8 = ItineraryItem(startAt: "11:00", endAt: "13:00", itineraryItemType: .movie(
            movie: Movie(id: 8, title: "Spiderman", duration: 120), theater: Theater(id: 20, name: "Cinemark"))
        )
        
        // when:
        let result = itineraryService.findConflicts(forItem: it1, inItems: [it1, it2, it3, it4, it5, it6, it7, it8])
        
        // then:
        #expect(result == [
            .sameStartTime(movie: Movie(id: 2, title: "Mad Max", duration: 120), theater: Theater(id: 10, name: "AMC")),
            .startTimeBeforeOtherMovieEnded(movie: Movie(id: 3, title: "Dracula", duration: 90), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 30),
            .endTimeAfterOtherMovieStarted(movie: Movie(id: 4, title: "The Godfather", duration: 180), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 30),
            .startTimeBeforeOtherMovieEnded(movie: Movie(id: 5, title: "Batman", duration: 150), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 90),
            .endTimeAfterOtherMovieStarted(movie: Movie(id: 6, title: "Short movie", duration: 10), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 20)
        ])
    }
    
    @Test func shouldCreateIntervalItemsBetweenOtherItems() async throws {
        // given:
        let someMovie = Movie(id: 1, title: "", duration: 60)
        let someTheater = Theater(id: 10, name: "")
        let anotherTheater = Theater(id: 20, name: "")
        let items = [
            ItineraryItem(startAt: "13:00", endAt: "14:00", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "14:30", endAt: "15:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "15:30", endAt: "16:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "17:30", endAt: "18:30", itineraryItemType: .movie(movie: someMovie, theater: anotherTheater)),
            ItineraryItem(startAt: "18:30", endAt: "19:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
        ]
        
        // when:
        let intervals = itineraryService.createIntervalsItems(betweeenItems: items)
        
        // then:
        #expect(intervals == [
            ItineraryItem(startAt: "14:00", endAt: "14:30", itineraryItemType: .interval()),
            ItineraryItem(startAt: "15:30", endAt: "15:30", itineraryItemType: .interval()),
            ItineraryItem(startAt: "16:30", endAt: "17:30", itineraryItemType: .interval(newTheater: anotherTheater)),
            ItineraryItem(startAt: "18:30", endAt: "18:30", itineraryItemType: .interval(newTheater: someTheater)),
        ])
    }
    
    @Test func shouldCreateIntervalItemsBetweenOtherItemsWithConflicts() async throws {
        // given:
        let someMovie = Movie(id: 1, title: "", duration: 60)
        let someShortMovie = Movie(id: 2, title: "", duration: 10)
        let someTheater = Theater(id: 10, name: "")
        let items = [
            ItineraryItem(startAt: "13:00", endAt: "14:00", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "13:30", endAt: "14:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "15:30", endAt: "16:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
            ItineraryItem(startAt: "15:40", endAt: "15:50", itineraryItemType: .movie(movie: someShortMovie, theater: someTheater)),
            ItineraryItem(startAt: "15:50", endAt: "16:00", itineraryItemType: .movie(movie: someShortMovie, theater: someTheater)),
            ItineraryItem(startAt: "18:30", endAt: "19:30", itineraryItemType: .movie(movie: someMovie, theater: someTheater)),
        ]
        
        // when:
        let intervals = itineraryService.createIntervalsItems(betweeenItems: items)
        
        // then:
        #expect(intervals == [
            ItineraryItem(startAt: "14:30", endAt: "15:30", itineraryItemType: .interval()),
            ItineraryItem(startAt: "16:30", endAt: "18:30", itineraryItemType: .interval()),
        ])
    }

}
