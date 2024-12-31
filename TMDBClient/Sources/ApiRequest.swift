//
//  ApiRequest.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

import Foundation

/** Represents a request to TMDB API. */
struct ApiRequest {
    
    let apiKey: String
    let endpoint: ApiEndpoint
    
    /** Converts this request to an URLRequest. */
    var urlRequest: URLRequest {
        var url = URL(string: "https://api.themoviedb.org/3")!
        url.appendPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        return request
    }
    
    init(apiKey: String, endpoint: ApiEndpoint) {
        self.apiKey = apiKey
        self.endpoint = endpoint
    }
}

