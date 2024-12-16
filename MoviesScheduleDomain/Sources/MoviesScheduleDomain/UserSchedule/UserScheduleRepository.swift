//
//  UserScheduleRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

@MainActor
public protocol UserScheduleRepository {
    func get() async throws(RetrieveError) -> UserSchedule?
    func save(_ userSchedule: UserSchedule) async throws(CreateError)
}
