//
//  ItineraryServiceTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Testing
@testable import MoviesScheduleDomain

@MainActor
struct ItineraryServiceTest {
    
    class UserScheduleRepositoryMock: UserScheduleRepository {
        
        private var userSchedule: UserSchedule = UserSchedule(items: [])
        
        func get() async throws(CrudError) -> UserSchedule? {
            return userSchedule
        }
        
        func save(_ userSchedule: UserSchedule) async throws(CrudError) {
            self.userSchedule = userSchedule
        }
    }
    
    class UserScheduleServiceMock: UserScheduleService {
        
        var userScheduleItemsData: [UserScheduleItemData] = []
        
        func getItemsData(_ userSchedule: UserSchedule) async -> [UserScheduleItemData] {
            return userScheduleItemsData
        }
    }
    
    private let itineraryService: ItineraryServiceImpl
    private let userScheduleRepository: UserScheduleRepositoryMock
    private let userScheduleService: UserScheduleServiceMock

    init() {
        userScheduleRepository = UserScheduleRepositoryMock()
        userScheduleService = UserScheduleServiceMock()
        itineraryService = ItineraryServiceImpl(userScheduleRepository: userScheduleRepository, userScheduleService: userScheduleService)
    }
    
    @Test func shouldCreateItineraryFromUserSchedule() async throws {
        // given:
        userScheduleService.userScheduleItemsData = [
            UserScheduleItemData(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30"
            ),
            UserScheduleItemData(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "21:00"
            ),
        ]
        
        // when:
        let itinerary = await itineraryService.createItinerary()
        
        // then:
        #expect(itinerary.items == [
            .movie(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30"
            ),
            .interval(duration: 270),
            .movie(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "21:00"
            )
        ])
    }
    
    @Test func shouldCreateItineraryWithConflicts() async throws {
        // given:
        userScheduleService.userScheduleItemsData = [
            UserScheduleItemData(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30"
            ),
            UserScheduleItemData(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30"
            ),
            UserScheduleItemData(
                movie: Movie(id: 3, title: "The Godfather", duration: 180),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "18:00"
            ),
            UserScheduleItemData(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "20:00"
            ),
            UserScheduleItemData(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "20:00"
            ),
        ]
        
        // when:
        let itinerary = await itineraryService.createItinerary()
        
        // then:
        #expect(itinerary.items == [
            .movieWithConflicts(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30",
                conflicts: [
                    ItineraryConflict.sameStartTime(
                        movie: Movie(id: 2, title: "Mad Max", duration: 120),
                        theater: Theater(id: 10, name: "AMC")
                    )
                ]
            ),
            .movieWithConflicts(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "14:30",
                conflicts: [
                    ItineraryConflict.sameStartTime(
                        movie: Movie(id: 1, title: "Star Wars", duration: 120),
                        theater: Theater(id: 10, name: "AMC")
                    )
                ]
            ),
            .interval(duration: 90),
            .movieWithConflicts(
                movie: Movie(id: 3, title: "The Godfather", duration: 180),
                theater: Theater(id: 10, name: "AMC"),
                schedule: "18:00",
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
            ),
            .movieWithConflicts(
                movie: Movie(id: 1, title: "Star Wars", duration: 120),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "20:00",
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
            ),
            .movieWithConflicts(
                movie: Movie(id: 2, title: "Mad Max", duration: 120),
                theater: Theater(id: 20, name: "Cinemark"),
                schedule: "20:00",
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
        ])
    }
    
    @Test func shouldCreateIntervalWithTimeBetweenTwoItems() throws {
        // given:
        let item1 = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "14:00"
        )
        let item2 = UserScheduleItemData(
            movie: Movie(id: 2, title: "Mad Max", duration: 90),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "16:30"
        )
        
        // when:
        let interval = itineraryService.createIntervalItem(betweenItem: item1, andItem: item2)
        
        // then:
        #expect(interval == .interval(duration: 30))
    }
    
    @Test func shouldCreateIntervalWithoutTimeBetweenTwoItems() throws {
        // given:
        let item1 = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "14:00"
        )
        let item2 = UserScheduleItemData(
            movie: Movie(id: 2, title: "Mad Max", duration: 90),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "16:00"
        )
        
        // when:
        let interval = itineraryService.createIntervalItem(betweenItem: item1, andItem: item2)
        
        // then:
        #expect(interval == .noInterval)
    }
    
    @Test func shouldCreateIntervalWithTimeBetweenTwoItemsWithDifferentTheaters() throws {
        // given:
        let item1 = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "14:00"
        )
        let item2 = UserScheduleItemData(
            movie: Movie(id: 2, title: "Mad Max", duration: 90),
            theater: Theater(id: 20, name: "Cinemark"),
            schedule: "16:30"
        )
        
        // when:
        let interval = itineraryService.createIntervalItem(betweenItem: item1, andItem: item2)
        
        // then:
        #expect(interval == .goToOtherTheater(availableTime: 30, theater: Theater(id: 20, name: "Cinemark")))
    }
    
    @Test func shouldCreateIntervalWithoutTimeBetweenTwoItemsWithDifferentTheaters() throws {
        // given:
        let item1 = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "14:00"
        )
        let item2 = UserScheduleItemData(
            movie: Movie(id: 2, title: "Mad Max", duration: 90),
            theater: Theater(id: 20, name: "Cinemark"),
            schedule: "16:00"
        )
        
        // when:
        let interval = itineraryService.createIntervalItem(betweenItem: item1, andItem: item2)
        
        // then:
        #expect(interval == .goToOtherTheaterWithoutTime(theater: Theater(id: 20, name: "Cinemark")))
    }
    
    @Test func shouldNotCreateIntervalBetweenTwoItemsIfSecondItemStartTimeIsBeforeFirstItemEndTime() throws {
        // given:
        let item1 = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "14:00"
        )
        let item2 = UserScheduleItemData(
            movie: Movie(id: 2, title: "Mad Max", duration: 90),
            theater: Theater(id: 10, name: "AMC"),
            schedule: "15:59"
        )
        
        // when:
        let interval = itineraryService.createIntervalItem(betweenItem: item1, andItem: item2)
        
        // then:
        #expect(interval == nil)
    }
    
    @Test func shouldFindConflicts() throws {
        // given:
        let it1 = UserScheduleItemData(movie: Movie(id: 1, title: "Star Wars", duration: 90), theater: Theater(id: 10, name: "AMC"), schedule: "13:00")
        let it2 = UserScheduleItemData(movie: Movie(id: 2, title: "Mad Max", duration: 120), theater: Theater(id: 10, name: "AMC"), schedule: "13:00")
        let it3 = UserScheduleItemData(movie: Movie(id: 3, title: "Dracula", duration: 90), theater: Theater(id: 20, name: "Cinemark"), schedule: "12:00")
        let it4 = UserScheduleItemData(movie: Movie(id: 4, title: "The Godfather", duration: 180), theater: Theater(id: 20, name: "Cinemark"), schedule: "14:00")
        let it5 = UserScheduleItemData(movie: Movie(id: 5, title: "Batman", duration: 150), theater: Theater(id: 20, name: "Cinemark"), schedule: "12:30")
        let it6 = UserScheduleItemData(movie: Movie(id: 6, title: "Short movie", duration: 20), theater: Theater(id: 20, name: "Cinemark"), schedule: "13:10")
        let it7 = UserScheduleItemData(movie: Movie(id: 7, title: "Jurassic Park", duration: 120), theater: Theater(id: 20, name: "Cinemark"), schedule: "14:30")
        let it8 = UserScheduleItemData(movie: Movie(id: 8, title: "Spiderman", duration: 120), theater: Theater(id: 20, name: "Cinemark"), schedule: "11:00")
        
        // when:
        let result = itineraryService.findConflicts(it1, others: [it1, it2, it3, it4, it5, it6, it7, it8])
        
        // then:
        #expect(result == [
            .sameStartTime(movie: Movie(id: 2, title: "Mad Max", duration: 120), theater: Theater(id: 10, name: "AMC")),
            .startTimeBeforeOtherMovieEnded(movie: Movie(id: 3, title: "Dracula", duration: 90), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 30),
            .endTimeAfterOtherMovieStarted(movie: Movie(id: 4, title: "The Godfather", duration: 180), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 30),
            .startTimeBeforeOtherMovieEnded(movie: Movie(id: 5, title: "Batman", duration: 150), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 90),
            .endTimeAfterOtherMovieStarted(movie: Movie(id: 6, title: "Short movie", duration: 20), theater: Theater(id: 20, name: "Cinemark"), conflictDuration: 20)
        ])
    }

}
