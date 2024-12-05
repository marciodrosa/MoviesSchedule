//
//  DependencySetup.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager
import MoviesScheduleApplication

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(ScheduleSelectionRouter.self) { getter in ScheduleSelectionRouterImpl() }
    ]
}
