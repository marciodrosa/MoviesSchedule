//
//  JsonResourceFileLoaderTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
import Foundation
@testable import MoviesScheduleDomain
@testable import MoviesScheduleInfrastructure

fileprivate struct JsonTestEntity: Decodable, Equatable {
    let id: Int64
    let name: String
}

fileprivate struct JsonTestEntityWithoutFile: Decodable, Equatable {
    let id: Int64
    let name: String
}

fileprivate struct JsonTestEntityWithDataErrors: Decodable, Equatable {
    let id: Int64
    let name: String
}

@MainActor
struct JsonResourceFileLoaderTest {
    
    let jsonResourceFileLoader: JsonResourceFileLoaderImpl
    
    init() {
        jsonResourceFileLoader = JsonResourceFileLoaderImpl(bundle: Bundle.module)
    }

    @Test func shouldLoadDataFromJsonFileWithSameNameAsType() async throws {
        // when:
        let result: [JsonTestEntity] = try! await jsonResourceFileLoader.load()
        
        // then:
        #expect(result == [
            JsonTestEntity(id: 10, name: "abc"),
            JsonTestEntity(id: 20, name: "def"),
            JsonTestEntity(id: 30, name: "ghi"),
        ])
    }
    
    @Test func shouldThrowUnreachableErrorWhenTryingToLoadDataWithoutAProperFile() async throws {
        await #expect(throws: RetrieveError.unreachable, performing: {
            let _: [JsonTestEntityWithoutFile] = try await jsonResourceFileLoader.load()
        })
    }
    
    @Test func shouldThrowInvalidErrorWhenTryingToLoadAnInvalidJsonData() async throws {
        await #expect(throws: RetrieveError.invalidData, performing: {
            let _: [JsonTestEntityWithDataErrors] = try await jsonResourceFileLoader.load()
        })
    }

}
