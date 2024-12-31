//
//  ApiError.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

/** Error related to a TMDB API call. */
public enum ApiError: Error {
    case http(statusCode: Int, localizedDescription: String)
    case data(underlyingError: DecodingError)
    case unknow(underlyingError: Error)
    
    public var localizedDescription: String {
        switch self {
        case .http(_, localizedDescription: let localizedDescription):
            localizedDescription
        case .data(underlyingError: let underlyingError):
            underlyingError.localizedDescription
        case .unknow(underlyingError: let underlyingError):
            underlyingError.localizedDescription
        }
    }
}
