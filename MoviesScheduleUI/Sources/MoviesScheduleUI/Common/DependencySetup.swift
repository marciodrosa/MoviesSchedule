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
        .mainActorFactory(ScheduleSelectionRouter.self) { getter in ScheduleSelectionRouterImpl() },
        .mainActorFactory(HomeViewFactory.self) { getter in HomeViewFactoryImpl(scheduleSelectionViewFactory: getter.mainActorGet(), itineraryViewFactory: getter.mainActorGet()) },
        .mainActorFactory(ItineraryViewFactory.self) { getter in ItineraryViewFactoryImpl() },
        .mainActorFactory(ScheduleSelectionViewFactory.self) { getter in ScheduleSelectionViewFactoryImpl() },
    ]
}
