//
//  ApiClient.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 30/12/24.
//

import Foundation
import Secrets

/** Client for the TMDB (themoviedb.org) API. The API key must be set in the Info.plist file using the key TMDBAPIKey. */
@MainActor
public protocol ApiClient: Sendable {
    
    /** Fetches the movie details by movie ID. Returns nil if not found.  */
    func getMovieDetails(id: Int64) async throws(ApiError) -> MovieDetails?
}

class ApiClientImpl: ApiClient {
    
    let urlSession: URLSession
    
    init() {
        urlSession = URLSession(configuration: .default)
    }
    
    func getMovieDetails(id: Int64) async throws(ApiError) -> MovieDetails? {
        return try await call(endpoint: .getMovieDetails(id: id))
    }
    
    private func call<T: Decodable>(endpoint: ApiEndpoint) async throws(ApiError) -> T? {
        let request = ApiRequest(apiKey: Secrets.tmdbApiKey.rawValue, endpoint: endpoint, locale: Locale.current)
        log(request.logString)
        do {
            let (data, _) = try await urlSession.data(for: request.urlRequest)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            log("API call returned successfully")
            return decodedData
        } catch {
            let apiError = ApiError.fromError(error)
            logError(apiError.localizedDescription)
            throw apiError
        }
    }
    
    private func log(_ message: String) {
        print(logString(message))
    }
    
    private func logError(_ error: String) {
        print(logString("[ERROR] \(error)"))
    }
    
    private func logString(_ content: String) -> String {
        "[TMDB API] \(content)"
    }
}
