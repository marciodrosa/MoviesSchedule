//
//  ApiEndpoint.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

/** List of endpoints of the TMDB API. */
enum ApiEndpoint {
    
    case getMovieDetails(id: Int64)
    
    var path: String {
        switch (self) {
        case .getMovieDetails(let id):
            return "movie/\(id)"
        }
    }
    
    var method: String {
        switch (self) {
        case .getMovieDetails:
            return "GET"
        }
    }
}

