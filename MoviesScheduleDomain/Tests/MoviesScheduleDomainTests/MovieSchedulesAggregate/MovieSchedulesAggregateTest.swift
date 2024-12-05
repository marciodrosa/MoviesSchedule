//
//  MovieSchedulesAggregateTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 29/11/24.
//

import Testing
import Foundation
@testable import MoviesScheduleDomain

class MovieSchedulesAggregateTest {
    
    var movieSchedulesAggregate: MovieSchedulesAggregate
    
    init() {
        let movie = Movie(id: 10, title: "Star Wars", duration: TimeInterval(120))
        let theaters = [
            Theater(id: 100, name: "Paradiso"),
            Theater(id: 200, name: "Majestic"),
        ]
        let schedules = [
            MovieSchedules(movieId: 10, theaterId: 100, schedules: ["15:00", "17:30"]),
            MovieSchedules(movieId: 10, theaterId: 200, schedules: ["17:00", "13:30"]),
        ]
        let userSelections = [
            UserSelection(movieId: 10, theaterId: 100, schedule: "15:00"),
            UserSelection(movieId: 10, theaterId: 200, schedule: "17:00"),
        ]
        movieSchedulesAggregate = MovieSchedulesAggregate(movie: movie, movieSchedules: schedules, theaters: theaters, userSelections: userSelections)
    }

    @Test func shouldReturnTheatersSchedules() async throws {
        // when:
        let result = movieSchedulesAggregate.theatersSchedules
        
        // then:
        #expect(result == [
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 200, name: "Majestic"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "13:30", selected: false),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:00", selected: true),
                ]
            ),
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 100, name: "Paradiso"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "15:00", selected: true),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:30", selected: false),
                ]
            ),
        ])
    }
    
    @Test func shouldSelectScheduleWhenToggleUnselectedSchedule() {
        // when:
        let result = movieSchedulesAggregate.toggleUserSelection(theaterId: 200, schedule: "13:30")
        
        // then:
        #expect(result)
        #expect(movieSchedulesAggregate.theatersSchedules == [
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 200, name: "Majestic"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "13:30", selected: true),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:00", selected: true),
                ]
            ),
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 100, name: "Paradiso"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "15:00", selected: true),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:30", selected: false),
                ]
            ),
        ])
    }
    
    @Test func shouldUnselectScheduleWhenToggleSelectedSchedule() {
        // when:
        let result = movieSchedulesAggregate.toggleUserSelection(theaterId: 200, schedule: "17:00")
        
        // then:
        #expect(!result)
        #expect(movieSchedulesAggregate.theatersSchedules == [
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 200, name: "Majestic"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "13:30", selected: false),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:00", selected: false),
                ]
            ),
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 100, name: "Paradiso"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "15:00", selected: true),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:30", selected: false),
                ]
            ),
        ])
    }
    
    @Test func shouldDoNothingWhenToggleUnknowSchedule() {
        // when:
        let result = movieSchedulesAggregate.toggleUserSelection(theaterId: 200, schedule: "22:00")
        
        // then:
        #expect(!result)
        #expect(movieSchedulesAggregate.theatersSchedules == [
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 200, name: "Majestic"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "13:30", selected: false),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:00", selected: true),
                ]
            ),
            MovieSchedulesAggregate.SchedulesByTheater(
                theater: Theater(id: 100, name: "Paradiso"),
                schedules: [
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "15:00", selected: true),
                    MovieSchedulesAggregate.SchedulesByTheater.UserSchedule(schedule: "17:30", selected: false),
                ]
            ),
        ])
    }

}
