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
public struct ScheduleSelectionViewFactory {
    
    public init() {
    }
    
    public func createView() -> ScheduleSelectionView<ScheduleSelectionViewModelImpl> {
        ScheduleSelectionView(viewModel: ScheduleSelectionViewModelImpl(router: DependenciesManager.getter!(), movieRepository: DependenciesManager.getter!(), userScheduleRepository: DependenciesManager.getter!(), theaterRepository: DependenciesManager.getter!()))
    }
}
