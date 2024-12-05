//
//  DependencySetup.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(MovieSchedulesAggregateService.self) { getter in
            MovieSchedulesAggregateServiceImpl(
                movieRepository: getter(),
                movieSchedulesRepository: getter(),
                theaterRepository: getter()
            )
        },
    ]
}
