//
//  ScheduleSelectionViewFactory.swift
//  MoviesScheduleUI
//
//  Created by Marcio Rosa on 05/12/24.
//

import SwiftUI
import DependenciesManager

@MainActor
public struct ScheduleSelectionViewFactory {
    
    public init() {
    }
    
    public func createView() -> ScheduleSelectionView {
        ScheduleSelectionView(viewModel: DependenciesManager.getter!())
    }
}
