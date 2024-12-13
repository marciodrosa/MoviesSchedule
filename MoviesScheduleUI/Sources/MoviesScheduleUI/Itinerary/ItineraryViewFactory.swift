//
//  ItineraryViewFactory.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI
import DependenciesManager
import MoviesScheduleApplication

@MainActor
protocol ItineraryViewFactory {
    func createView() -> any View
}

struct ItineraryViewFactoryImpl: ItineraryViewFactory {
    
    func createView() -> any View {
        ItineraryView(viewModel: ItineraryViewModelImpl(itineraryService: DependenciesManager.getter!()))
    }
}
