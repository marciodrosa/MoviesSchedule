//
//  ApiErrorTest.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 31/12/24.
//

import Testing
@testable import TMDBClient

fileprivate struct GenericError: Error {
    var localizedDescription: String {
        "Generic error"
    }
}

struct ApiErrorTest {

    @Test func shouldReturnLocalizedDescriptionOfError() async throws {
        #expect(ApiError.http(statusCode: 404, localizedDescription: "Not found").localizedDescription == "Not found")
    }

}
