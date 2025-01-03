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
    
    /** This request converted to an URLRequest. */
    let urlRequest: URLRequest
    
    var logString: String {
        return "\(endpoint.method) \(urlRequest.url?.absoluteString ?? "")"
    }
    
    init(apiKey: String, endpoint: ApiEndpoint, locale: Locale? = nil) {
        self.apiKey = apiKey
        self.endpoint = endpoint
        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3")!
        if let locale, let languageCode = locale.languageCode, let regionCode = locale.regionCode {
            urlComponents.queryItems = [
                URLQueryItem(name: "language", value: "\(languageCode)-\(regionCode)")
            ]
        }
        var url = urlComponents.url!
        url.appendPathComponent(endpoint.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        self.urlRequest = urlRequest
    }
}
