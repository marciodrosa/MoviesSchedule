//
//  MovieFromFileRepositoryTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

@MainActor
struct MovieFromFileRepositoryTest {
    
    static let mockedData = [
        Movie(id: 1, title: "The Jigsaw Man", duration: 94),
        Movie(id: 2, title: "The Bikeriders", duration: 116),
    ]
    
    struct JsonResourceFileLoaderMock: JsonResourceFileLoader {
        
        func load<T>() async throws(CrudError) -> [T] where T : Decodable, T : Sendable {
            return mockedData as! [T]
        }
    }
    
    let repository: MovieFromFileRepository
    
    init() {
        repository = MovieFromFileRepository(jsonResourceFileLoader: JsonResourceFileLoaderMock())
    }

    @Test func shouldGetAllMoviesFromJsonFile() async throws {
        // when:
        let result = try! await repository.getAll()
        
        // then:
        #expect(result == MovieFromFileRepositoryTest.mockedData)
    }

}
