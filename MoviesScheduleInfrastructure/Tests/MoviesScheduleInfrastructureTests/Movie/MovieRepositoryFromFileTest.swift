//
//  MovieRepositoryFromFileTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

struct MovieRepositoryFromFileTest {
    
    static let mockedData = [
        Movie(id: 1, title: "The Jigsaw Man", duration: 94),
        Movie(id: 2, title: "The Bikeriders", duration: 116),
    ]
    
    actor JsonResourceFileLoaderMock: JsonResourceFileLoader {
        
        func load<T>() async throws(RetrieveError) -> [T] where T : Decodable, T : Sendable {
            return mockedData as! [T]
        }
    }
    
    let repository: MovieRepositoryFromFile
    
    init() {
        repository = MovieRepositoryFromFile(jsonResourceFileLoader: JsonResourceFileLoaderMock())
    }

    @Test func shouldGetAllMoviesFromJsonFile() async throws {
        // when:
        let result = try! await repository.getAll()
        
        // then:
        #expect(result == MovieRepositoryFromFileTest.mockedData)
    }

}
