//
//  Movie+ExtensionsTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 31/12/24.
//

import Testing
import TMDBClient
import MoviesScheduleDomain
@testable import MoviesScheduleInfrastructure

struct MovieExtensionsTest {

    @Test func shouldCreateFromTMDBMovieDetails() async throws {
        // given:
        let tmdbMovieDetails = TMDBClient.MovieDetails(id: 10, runtime: 120, title: "Star Wars")
        
        // when:
        let domainMovieObject = Movie(withTMDBMovieDetails: tmdbMovieDetails)
        
        // then:
        #expect(domainMovieObject == Movie(id: 10, title: "Star Wars", duration: 120))
    }

}
