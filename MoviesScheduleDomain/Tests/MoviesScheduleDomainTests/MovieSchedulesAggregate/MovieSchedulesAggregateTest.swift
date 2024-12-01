//
//  MovieSchedulesAggregateTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 29/11/24.
//

import Testing
import Foundation
@testable import MoviesScheduleDomain

struct MovieSchedulesAggregateTest {

    @Test func shouldReturnTheatersSchedules() async throws {
        // given:
        let movie = Movie(id: 10, title: "Star Wars", duration: TimeInterval(120))
        let theaters = [
            Theater(id: 100, name: "Paradiso"),
            Theater(id: 200, name: "Majestic"),
        ]
        let schedules = [
            MovieSchedules(movieId: 10, theaterId: 100, schedules: ["15:00", "17:30"]),
            MovieSchedules(movieId: 10, theaterId: 200, schedules: ["17:00", "13:30"]),
        ]
        let movieSchedulesAggregate = MovieSchedulesAggregate(movie: movie, movieSchedules: schedules, theaters: theaters)
        
        // when:
        let result = movieSchedulesAggregate.theatersSchedules
        
        // then:
        #expect(result == [
            MovieSchedulesAggregate.Schedules(theater: Theater(id: 200, name: "Majestic"), schedules: ["13:30", "17:00"]),
            MovieSchedulesAggregate.Schedules(theater: Theater(id: 100, name: "Paradiso"), schedules: ["15:00", "17:30"]),
        ])
    }

}
