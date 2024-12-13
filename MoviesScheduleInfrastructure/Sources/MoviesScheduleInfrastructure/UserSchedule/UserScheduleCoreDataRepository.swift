//
//  UserScheduleRepositoryCoreData.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 06/12/24.
//

import MoviesScheduleDomain

actor UserScheduleCoreDataRepository: UserScheduleRepository {
    
    static var userSchedule: UserSchedule? = nil
    
    func get() async throws(RetrieveError) -> UserSchedule? {
        return UserScheduleCoreDataRepository.userSchedule
    }
    
    func save(_ userSchedule: UserSchedule) async throws(CreateError) {
        UserScheduleCoreDataRepository.userSchedule = userSchedule
    }
    
}
