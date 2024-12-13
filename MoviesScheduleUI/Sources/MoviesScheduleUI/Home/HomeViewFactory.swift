//
//  HomeViewFactory.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI
import DependenciesManager

@MainActor
protocol HomeViewFactory {
    func createView() -> any View
}

struct HomeViewFactoryImpl: HomeViewFactory {
    
    let scheduleSelectionViewFactory: ScheduleSelectionViewFactory
    let itineraryViewFactory: ItineraryViewFactory
    
    init(scheduleSelectionViewFactory: ScheduleSelectionViewFactory, itineraryViewFactory: ItineraryViewFactory) {
        self.scheduleSelectionViewFactory = scheduleSelectionViewFactory
        self.itineraryViewFactory = itineraryViewFactory
    }
    
    public func createView() -> any View {
        HomeView(scheduleSelectionViewFactory: scheduleSelectionViewFactory, itineraryViewFactory: itineraryViewFactory)
    }
}
