//
//  DependencySetup.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .mainActorFactory(ScheduleSelectionViewModel.self, { getter in
            ScheduleSelectionViewModelImpl(router: getter(), movieRepository: getter(), userScheduleRepository: getter(), theaterRepository: getter())
        })
    ]
}
