//
//  ApiError.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

import Foundation

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
    
    static func fromError(_ error: Error) -> ApiError {
        if let error = error as? URLError {
            return .http(statusCode: error.errorCode, localizedDescription: error.localizedDescription)
        }
        if let error = error as? DecodingError {
            return .data(underlyingError: error)
        }
        return .unknow(underlyingError: error)
    }
}
