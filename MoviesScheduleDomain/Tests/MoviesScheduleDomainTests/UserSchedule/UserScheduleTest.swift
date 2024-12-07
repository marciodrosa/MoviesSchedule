//
//  UserScheduleTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 06/12/24.
//

import Testing
@testable import MoviesScheduleDomain

class UserScheduleTest {
    
    var userSchedule: UserSchedule
    
    let movie1 = Movie(id: 1, title: "Star Wars", duration: 120)
    let movie2 = Movie(id: 2, title: "Mad Max", duration: 120)
    let movie3 = Movie(id: 3, title: "The Godfather", duration: 180)
    
    let theater1 = Theater(id: 10, name: "AMC")
    let theater2 = Theater(id: 20, name: "Cinemark")
    let theater3 = Theater(id: 30, name: "New Beverly")
    
    init() {
        userSchedule = UserSchedule(items: [
            UserScheduleItem(movieId: movie1.id, theaterId: theater1.id, schedule: "16:30"),
            UserScheduleItem(movieId: movie2.id, theaterId: theater2.id, schedule: "20:30"),
        ])
    }
    
    @Test func shouldReturnIfScheduleIsSelected() async throws {
        #expect(userSchedule.isItemSelected(movie: movie1, theater: theater1, schedule: "16:30"))
        #expect(userSchedule.isItemSelected(movie: movie2, theater: theater2, schedule: "20:30"))
        #expect(!userSchedule.isItemSelected(movie: movie1, theater: theater1, schedule: "17:30"))
        #expect(!userSchedule.isItemSelected(movie: movie1, theater: theater2, schedule: "16:30"))
        #expect(!userSchedule.isItemSelected(movie: movie2, theater: theater1, schedule: "16:30"))
    }
    
    @Test func shouldToggleAndSelectAMovieTheaterAndSchedule() async throws {
        // when:
        let result = userSchedule.toggleScheduleItem(movie: movie3, theater: theater3, schedule: "20:00")
        
        // then:
        #expect(result)
        #expect(userSchedule.isItemSelected(movie: movie3, theater: theater3, schedule: "20:00"))
    }
    
    @Test func shouldToggleAndUnselectAMovieTheaterAndSchedule() async throws {
        // when:
        let result = userSchedule.toggleScheduleItem(movie: movie1, theater: theater1, schedule: "16:30")
        
        // then:
        #expect(!result)
        #expect(!userSchedule.isItemSelected(movie: movie1, theater: theater1, schedule: "16:30"))
    }

}
