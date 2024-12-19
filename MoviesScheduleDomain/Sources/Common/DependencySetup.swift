//
//  DependencySetup.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(ItineraryService.self) { getter in ItineraryServiceImpl(userScheduleRepository: getter(), userScheduleService: getter()) },
        .factory(UserScheduleService.self) { getter in UserScheduleServiceImpl(movieRepository: getter(), theaterRepository: getter()) }
    ]
}
