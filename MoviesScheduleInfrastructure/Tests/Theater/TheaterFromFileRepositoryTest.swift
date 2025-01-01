//
//  TheaterFromFileRepositoryTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

@MainActor
struct TheaterFromFileRepositoryTest {
    
    static let mockedTheaterData = [
        Theater(id: 1, name: "AMC"),
        Theater(id: 2, name: "Cinemark"),
        Theater(id: 3, name: "New Beverly")
    ]
    
    static let mockedSchedulesData = [
        MovieSchedules(movieId: 10, theaterId: 1, schedules: ["14:00", "16:00"]),
        MovieSchedules(movieId: 20, theaterId: 1, schedules: ["17:00", "19:00"]),
        MovieSchedules(movieId: 10, theaterId: 2, schedules: ["20:30"]),
        MovieSchedules(movieId: 10, theaterId: 3, schedules: ["15:30"]),
        MovieSchedules(movieId: 30, theaterId: 3, schedules: ["16:30"]),
    ]
    
    class JsonResourceFileLoaderMock: JsonResourceFileLoader {
        
        func load<T>() async throws(CrudError) -> [T] where T : Decodable, T : Sendable {
            if T.self == Theater.self {
                return mockedTheaterData as! [T]
            } else if T.self == MovieSchedules.self {
                return mockedSchedulesData as! [T]
            }
            return []
        }
    }
    
    let repository: TheaterFromFileRepository
    
    init() {
        repository = TheaterFromFileRepository(jsonResourceFileLoader: JsonResourceFileLoaderMock())
    }

    @Test func shouldGetByMovieIdsFromJsonFile() async throws {
        // when:
        let result = try! await repository.get(byMovieIds: [20, 30])
        
        // then:
        #expect(result == [
            Theater(id: 1, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 20, theaterId: 1, schedules: ["17:00", "19:00"]),
            ]),
            Theater(id: 3, name: "New Beverly", movieSchedules: [
                MovieSchedules(movieId: 30, theaterId: 3, schedules: ["16:30"]),
            ])
        ])
    }
    
    @Test func shouldGetByIdsFromJsonFile() async throws {
        // when:
        let result = try! await repository.get(byIds: [1, 3])
        
        // then:
        #expect(result == [
            Theater(id: 1, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 10, theaterId: 1, schedules: ["14:00", "16:00"]),
                MovieSchedules(movieId: 20, theaterId: 1, schedules: ["17:00", "19:00"]),
            ]),
            Theater(id: 3, name: "New Beverly", movieSchedules: [
                MovieSchedules(movieId: 10, theaterId: 3, schedules: ["15:30"]),
                MovieSchedules(movieId: 30, theaterId: 3, schedules: ["16:30"]),
            ])
        ])
    }
    
    @Test func shouldGetAllFromJsonFile() async throws {
        // when:
        let result = try! await repository.getAll()
        
        // then:
        #expect(result == [
            Theater(id: 1, name: "AMC", movieSchedules: [
                MovieSchedules(movieId: 10, theaterId: 1, schedules: ["14:00", "16:00"]),
                MovieSchedules(movieId: 20, theaterId: 1, schedules: ["17:00", "19:00"]),
            ]),
            Theater(id: 2, name: "Cinemark", movieSchedules: [
                MovieSchedules(movieId: 10, theaterId: 2, schedules: ["20:30"]),
            ]),
            Theater(id: 3, name: "New Beverly", movieSchedules: [
                MovieSchedules(movieId: 10, theaterId: 3, schedules: ["15:30"]),
                MovieSchedules(movieId: 30, theaterId: 3, schedules: ["16:30"]),
            ])
        ])
    }

}
