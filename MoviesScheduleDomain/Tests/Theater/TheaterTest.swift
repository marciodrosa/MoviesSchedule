//
//  TheaterTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 06/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct TheaterTest {
    
    let theater: Theater
    
    init() {
        theater = Theater(id: 1, name: "AMC", movieSchedules: [
            MovieSchedules(movieId: 10, theaterId: 1, schedules: ["13:00", "15:00"]),
            MovieSchedules(movieId: 20, theaterId: 1, schedules: ["16:00", "18:00"]),
            MovieSchedules(movieId: 30, theaterId: 1, schedules: ["19:00", "21:30"]),
        ])
    }
    
    @Test func shouldReturnSchedulesByMovie() async throws {
        #expect(theater.schedules(byMovie: Movie(id: 20, title: "", duration: 120)) == ["16:00", "18:00"])
    }
    
    @Test func shouldReturnIfMovieHasSchedulesForMovie() async throws {
        #expect(theater.hasMovie(Movie(id: 20, title: "", duration: 120)))
        #expect(!theater.hasMovie(Movie(id: 40, title: "", duration: 120)))
    }

}
