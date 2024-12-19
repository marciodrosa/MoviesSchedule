//
//  UserScheduleRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

/** Repository for the user schedule entity. */
@MainActor
public protocol UserScheduleRepository {
    func get() async throws(CrudError) -> UserSchedule?
    func save(_ userSchedule: UserSchedule) async throws(CrudError)
}
