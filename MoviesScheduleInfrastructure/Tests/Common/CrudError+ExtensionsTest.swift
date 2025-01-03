//
//  CrudError+ExtensionsTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 31/12/24.
//

import Testing
import TMDBClient
import MoviesScheduleDomain
@testable import MoviesScheduleInfrastructure

fileprivate struct SomeError: Error {
}

struct CrudErrorExtensionsTest {

    @Test func shouldCreateFromTMDBError() async throws {
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.http(statusCode: 400, localizedDescription: "")) == .invalidInput)
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.http(statusCode: 403, localizedDescription: "")) == .forbidden)
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.http(statusCode: 404, localizedDescription: "")) == .notFound)
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.http(statusCode: 500, localizedDescription: "")) == .unknownExternalError)
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.http(statusCode: 501, localizedDescription: "")) == .unknow)
        #expect(CrudError.from(tmdbError: TMDBClient.ApiError.unknow(underlyingError: SomeError())) == .unknow)
    }

}
