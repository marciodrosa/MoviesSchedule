//
//  MovieTest.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 12/12/24.
//

import Testing
@testable import MoviesScheduleDomain

struct MovieTest {
    
    @Test func shouldCalculateEndsAt() {
        // given:
        let movie = Movie(id: 1, title: "Star Wars", duration: 120)
        
        // then
        #expect(movie.endsAt(whenStartingAt: "16:30") == "18:30")
    }
}
