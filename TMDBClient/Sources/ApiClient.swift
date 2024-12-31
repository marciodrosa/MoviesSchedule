//
//  ApiClient.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 30/12/24.
//

import Foundation

/** Client for the TMDB (themoviedb.org) API. */
@MainActor
public protocol ApiClient {
    
    /** Fetches the movie details by movie ID. Returns nil if not found.  */
    func getMovieDetails(id: Int64) async throws(ApiError) -> MovieDetails?
}

class ApiClientImpl: ApiClient {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getMovieDetails(id: Int64) async throws(ApiError) -> MovieDetails? {
        return try await call(endpoint: .getMovieDetails(id: id))
    }
    
    private func call<T: Decodable>(endpoint: ApiEndpoint) async throws(ApiError) -> T? {
        let request = ApiRequest(apiKey: apiKey, endpoint: endpoint)
        do {
            let (data, _) = try await URLSession.shared.data(for: request.urlRequest)
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as URLError {
            throw .http(statusCode: error.errorCode, localizedDescription: error.localizedDescription)
        } catch let error as DecodingError {
            throw .data(underlyingError: error)
        } catch {
            throw .unknow(underlyingError: error)
        }
    }
}
