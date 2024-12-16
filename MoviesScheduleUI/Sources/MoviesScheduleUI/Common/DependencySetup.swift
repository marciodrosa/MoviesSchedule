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
        .factory(ScheduleSelectionRouter.self) { getter in ScheduleSelectionRouterImpl() },
        .factory(HomeViewFactory.self) { getter in HomeViewFactoryImpl(scheduleSelectionViewFactory: getter(), itineraryViewFactory: getter()) },
        .factory(ItineraryViewFactory.self) { getter in ItineraryViewFactoryImpl() },
        .factory(ScheduleSelectionViewFactory.self) { getter in ScheduleSelectionViewFactoryImpl() },
    ]
}
