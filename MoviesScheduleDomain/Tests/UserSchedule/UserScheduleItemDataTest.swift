//
//  UserScheduleItemDataTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 11/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct UserScheduleItemDataTest {
    
    @Test func shouldCalculateEndsAt() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        let item = UserScheduleItemData(
            movie: Movie(id: 1, title: "Star Wars", duration: 120),
            theater: Theater(id: 1, name: ""),
            schedule: "16:30"
        )
        
        // then
        #expect(item.endsAt == "18:30")
    }
    
    @Test func shouldReturnTrueIfMovieEndsInConflictWithAnotherSchedule() {
        // given:
        let movie1 = Movie(id: 1, title: "", duration: 120)
        let movie2 = Movie(id: 2, title: "", duration: 180)
        let movie3 = Movie(id: 3, title: "", duration: 90)
        let theater = Theater(id: 1, name: "")
        
        // then:
        #expect(
            UserScheduleItemData(movie: movie1, theater: theater, schedule: "14:00").isEndOfMovieInConflictWithOthers([
                UserScheduleItemData(movie: movie2, theater: theater, schedule: "15:59")
            ])
        )
        #expect(
            UserScheduleItemData(movie: movie1, theater: theater, schedule: "14:00").isEndOfMovieInConflictWithOthers([
                UserScheduleItemData(movie: movie2, theater: theater, schedule: "13:01")
            ])
        )
        #expect(
            UserScheduleItemData(movie: movie1, theater: theater, schedule: "14:00").isEndOfMovieInConflictWithOthers([
                UserScheduleItemData(movie: movie3, theater: theater, schedule: "14:31")
            ])
        )
    }
    
    @Test func shouldReturnFalseIfMovieDoesNotEndInConflictWithAnotherSchedule() {
        // given:
        let movie1 = Movie(id: 1, title: "", duration: 120)
        let movie2 = Movie(id: 1, title: "", duration: 180)
        let movie3 = Movie(id: 1, title: "", duration: 90)
        let theater = Theater(id: 1, name: "")
        
        // then:
        #expect(
            !UserScheduleItemData(movie: movie1, theater: theater, schedule: "14:00").isEndOfMovieInConflictWithOthers([
                UserScheduleItemData(movie: movie2, theater: theater, schedule: "16:00"),
                UserScheduleItemData(movie: movie2, theater: theater, schedule: "13:00"),
                UserScheduleItemData(movie: movie3, theater: theater, schedule: "14:30")
            ])
        )
    }
    
}
