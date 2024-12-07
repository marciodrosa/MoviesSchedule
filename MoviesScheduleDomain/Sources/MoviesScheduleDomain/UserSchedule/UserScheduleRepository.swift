//
//  UserScheduleRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

public protocol UserScheduleRepository: Sendable {
    func get() async throws(RetrieveError) -> UserSchedule?
    func save(_ userSchedule: UserSchedule) async throws(CreateError)
}
