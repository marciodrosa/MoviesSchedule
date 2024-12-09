//
//  ItineraryItemTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct ItineraryItemTest {
    
    let movie = Movie(id: 1, title: "Star Wars", duration: 125)
    let theater = Theater(id: 1, name: "AMC")

    @Test func shouldReturnTimeOfDayOfItineraryItem() async throws {
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "13:50").timeOfDay == "13:50")
        #expect(ItineraryItem.movieWithSameScheduleConflict(movie: movie, theater: theater, schedule: "13:50").timeOfDay == "13:50")
        #expect(ItineraryItem.movieWithOverlappingScheduleConflict(movie: movie, theater: theater, schedule: "13:50", overlappingDuration: 30).timeOfDay == "13:50")
        #expect(ItineraryItem.goToTheater(timeOfDay: "15:20", duration: 60).timeOfDay == "15:20")
        #expect(ItineraryItem.interval(timeOfDay: "15:20", duration: 60).timeOfDay == "15:20")
    }
    
    @Test func shouldReturnDurationOfItineraryItem() async throws {
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "13:50").duration == 125)
        #expect(ItineraryItem.movieWithSameScheduleConflict(movie: movie, theater: theater, schedule: "13:50").duration == 125)
        #expect(ItineraryItem.movieWithOverlappingScheduleConflict(movie: movie, theater: theater, schedule: "13:50", overlappingDuration: 30).duration == 125)
        #expect(ItineraryItem.goToTheater(timeOfDay: "15:20", duration: 60).duration == 60)
        #expect(ItineraryItem.interval(timeOfDay: "15:20", duration: 60).duration == 60)
    }
    
    @Test func shouldReturnEndTimeOfDayOfItineraryItem() async throws {
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "13:50").endTimeOfDay == "15:55")
        #expect(ItineraryItem.movieWithSameScheduleConflict(movie: movie, theater: theater, schedule: "13:50").endTimeOfDay == "15:55")
        #expect(ItineraryItem.movieWithOverlappingScheduleConflict(movie: movie, theater: theater, schedule: "13:50", overlappingDuration: 30).endTimeOfDay == "15:55")
        #expect(ItineraryItem.goToTheater(timeOfDay: "15:20", duration: 60).endTimeOfDay == "16:20")
        #expect(ItineraryItem.interval(timeOfDay: "15:20", duration: 60).endTimeOfDay == "16:20")
    }

}
