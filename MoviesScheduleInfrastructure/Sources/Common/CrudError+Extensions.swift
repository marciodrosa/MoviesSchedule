//
//  CrudError+Extensions.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 31/12/24.
//

import Foundation
import MoviesScheduleDomain
import TMDBClient

extension CrudError {
    
    static func from(tmdbError: TMDBClient.ApiError) ->CrudError {
        switch tmdbError {
        case .http(statusCode: let statusCode, _):
            switch statusCode {
            case 400:
                return .invalidInput
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 500:
                return .unknownExternalError
            default:
                return .unknow
            }
        case .data:
            return .invalidData
        case .unknow:
            return .unknow
        }
    }
}
