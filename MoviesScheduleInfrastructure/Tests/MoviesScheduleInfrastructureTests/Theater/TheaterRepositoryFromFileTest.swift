//
//  TheaterRepositoryFromFileTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

struct TheaterRepositoryFromFileTest {
    
    static let mockedData = [
        Theater(id: 1, name: "AMC"),
        Theater(id: 2, name: "Cinemark"),
        Theater(id: 3, name: "New Beverly")
    ]
    
    actor JsonResourceFileLoaderMock: JsonResourceFileLoader {
        
        func load<T>() async throws(RetrieveError) -> [T] where T : Decodable, T : Sendable {
            return mockedData as! [T]
        }
    }
    
    let repository: TheaterRepositoryFromFile
    
    init() {
        repository = TheaterRepositoryFromFile(jsonResourceFileLoader: JsonResourceFileLoaderMock())
    }

    @Test func shouldGetAllMoviesFromJsonFile() async throws {
        // when:
        let result = try! await repository.get(byIds: [1, 3])
        
        // then:
        #expect(result == [
            Theater(id: 1, name: "AMC"),
            Theater(id: 3, name: "New Beverly")
        ])
    }

}
