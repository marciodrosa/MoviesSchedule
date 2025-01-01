//
//  ApiRequestTest.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

import Testing
@testable import TMDBClient

struct ApiRequestTest {

    @Test func shouldConvertRequestToURLRequest() async throws {
        // given:
        let request = ApiRequest(apiKey: "ABC123", endpoint: .getMovieDetails(id: 10))
        
        // when:
        let urlRequest = request.urlRequest
        
        // then:
        #expect(urlRequest.url?.absoluteString == "https://api.themoviedb.org/3/movie/10")
        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.value(forHTTPHeaderField: "Authorization") == "Bearer ABC123")
        #expect(urlRequest.value(forHTTPHeaderField: "accept") == "application/json")
    }
    
    @Test func shouldConvertToLogString() async throws {
        // given:
        let request = ApiRequest(apiKey: "ABC123", endpoint: .getMovieDetails(id: 10))
        
        // then:
        #expect(request.logString == "GET https://api.themoviedb.org/3/movie/10")
    }

}
