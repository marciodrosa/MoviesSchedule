//
//  ApiClientFactory.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

/** Object that makes an API Client for TMDB. */
@MainActor
public struct ApiClientFactory {
    
    /** Creates and returns a new client instance with the given API key. */
    public func create(apiKey: String) ->ApiClient {
        return ApiClientImpl(apiKey: apiKey)
    }
}
