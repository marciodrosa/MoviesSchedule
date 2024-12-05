//
//  DependencySetup.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(ScheduleSelectionViewModel.self) { getter in ScheduleSelectionViewModelImpl(router: getter(), movieSchedulesAggregateService: getter()) },
    ]
}
