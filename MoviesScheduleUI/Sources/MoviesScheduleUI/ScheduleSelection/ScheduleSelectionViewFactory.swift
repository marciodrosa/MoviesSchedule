//
//  ScheduleSelectionViewFactory.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 05/12/24.
//

import SwiftUI
import DependenciesManager
import MoviesScheduleApplication

@MainActor
protocol ScheduleSelectionViewFactory {
    func createView() -> any View
}

@MainActor
struct ScheduleSelectionViewFactoryImpl: ScheduleSelectionViewFactory {
    
    public func createView() -> any View {
        ScheduleSelectionView(viewModel: ScheduleSelectionViewModelImpl(router: DependenciesManager.getter!(), movieRepository: DependenciesManager.getter!(), userScheduleRepository: DependenciesManager.getter!(), theaterRepository: DependenciesManager.getter!()))
    }
}
