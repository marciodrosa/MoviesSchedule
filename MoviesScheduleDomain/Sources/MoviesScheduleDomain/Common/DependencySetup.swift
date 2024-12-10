//
//  DependencySetup.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(ItineraryService.self) { getter in ItineraryServiceImpl(movieRepository: getter(), theaterRepository: getter(), userScheduleRepository: getter()) }
    ]
}
