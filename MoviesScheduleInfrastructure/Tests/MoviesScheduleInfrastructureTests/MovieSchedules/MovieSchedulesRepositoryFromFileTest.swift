//
//  MovieSchedulesRepositoryFromFileTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

struct MovieSchedulesRepositoryFromFileTest {
    
    static let mockedData = [
        MovieSchedules(movieId: 1, theaterId: 10, schedules: ["12:00", "15:00"]),
        MovieSchedules(movieId: 2, theaterId: 10, schedules: ["16:00", "21:00"]),
        MovieSchedules(movieId: 2, theaterId: 20, schedules: ["14:00"])
    ]
    
    actor JsonResourceFileLoaderMock: JsonResourceFileLoader {
        
        func load<T>() async throws(RetrieveError) -> [T] where T : Decodable, T : Sendable {
            return mockedData as! [T]
        }
    }
    
    let repository: MovieSchedulesRepositoryFromFile
    
    init() {
        repository = MovieSchedulesRepositoryFromFile(jsonResourceFileLoader: JsonResourceFileLoaderMock())
    }

    @Test func shouldGetAllMoviesFromJsonFile() async throws {
        // when:
        let result = try! await repository.get(byMovieId: 2)
        
        // then:
        #expect(result == [
            MovieSchedules(movieId: 2, theaterId: 10, schedules: ["16:00", "21:00"]),
            MovieSchedules(movieId: 2, theaterId: 20, schedules: ["14:00"])
        ])
    }

}
