//
//  ItineraryItemTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 09/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct ItineraryItemTest {
    
    @Test func shouldReturnAssociatedMovie() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        
        // then
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "14:00").movie == movie)
        #expect(ItineraryItem.movieWithConflicts(movie: movie, theater: theater, schedule: "14:00", conflicts: []).movie == movie)
        #expect(ItineraryItem.goToOtherTheater(availableTime: 10, theater: theater).movie == nil)
        #expect(ItineraryItem.goToOtherTheaterWithoutTime(theater: theater).movie == nil)
        #expect(ItineraryItem.interval(duration: 10).movie == nil)
        #expect(ItineraryItem.noInterval.movie == nil)
    }
    
    @Test func shouldReturnAssociatedTheater() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        
        // then
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "14:00").theater == theater)
        #expect(ItineraryItem.movieWithConflicts(movie: movie, theater: theater, schedule: "14:00", conflicts: []).theater == theater)
        #expect(ItineraryItem.goToOtherTheater(availableTime: 10, theater: theater).theater == theater)
        #expect(ItineraryItem.goToOtherTheaterWithoutTime(theater: theater).theater == theater)
        #expect(ItineraryItem.interval(duration: 10).theater == nil)
        #expect(ItineraryItem.noInterval.theater == nil)
    }
    
    @Test func shouldReturnItineraryItemDuration() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        let theater = Theater(id: 10, name: "AMC")
        
        // then
        #expect(ItineraryItem.movie(movie: movie, theater: theater, schedule: "14:00").duration == 120)
        #expect(ItineraryItem.movieWithConflicts(movie: movie, theater: theater, schedule: "14:00", conflicts: []).duration == 120)
        #expect(ItineraryItem.goToOtherTheater(availableTime: 10, theater: theater).duration == 10)
        #expect(ItineraryItem.goToOtherTheaterWithoutTime(theater: theater).duration == 0)
        #expect(ItineraryItem.interval(duration: 10).duration == 10)
        #expect(ItineraryItem.noInterval.duration == 0)
    }
}
