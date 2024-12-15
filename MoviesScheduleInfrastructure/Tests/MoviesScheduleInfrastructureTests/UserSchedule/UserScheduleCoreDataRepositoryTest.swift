//
//  UserScheduleCoreDataRepositoryTest.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 14/12/24.
//

import Testing
@testable import MoviesScheduleInfrastructure
import MoviesScheduleDomain

struct UserScheduleCoreDataRepositoryTest {
    
    let repository: UserScheduleCoreDataRepository
    let coreDataManager = CoreDataManagerImpl()
    
    init() {
        repository = UserScheduleCoreDataRepository(coreDataManager: coreDataManager)
    }

    @Test func shouldSaveAndRetrieve() async throws {
        // given:
        let userSchedule = UserSchedule(items: [
            UserScheduleItem(movieId: 1, theaterId: 10, schedule: "13:30"),
            UserScheduleItem(movieId: 2, theaterId: 20, schedule: "15:30"),
            UserScheduleItem(movieId: 3, theaterId: 30, schedule: "19:30"),
        ])
        
        // when:
        try await repository.save(userSchedule)
        let retrievedUserSchedule = try await repository.get()
        
        // then:
        #expect(retrievedUserSchedule?.items.sorted { $0.schedule < $1.schedule } ?? [] == userSchedule.items)
    }
    
    @Test func shouldRetrieveNilScheduleIfNothingIsSaved() async throws {
        // when:
        let retrievedUserSchedule = try await repository.get()
        
        // then:
        #expect(retrievedUserSchedule == nil)
    }

}

