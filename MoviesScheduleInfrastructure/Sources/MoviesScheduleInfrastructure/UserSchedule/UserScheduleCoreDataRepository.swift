//
//  UserScheduleRepositoryCoreData.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 06/12/24.
//

import MoviesScheduleDomain

actor UserScheduleCoreDataRepository: UserScheduleRepository {
    func get() async throws(MoviesScheduleDomain.RetrieveError) -> MoviesScheduleDomain.UserSchedule? {
        return nil
    }
    
    func save(_ userSchedule: MoviesScheduleDomain.UserSchedule) async throws(MoviesScheduleDomain.CreateError) {
        
    }
    
}
