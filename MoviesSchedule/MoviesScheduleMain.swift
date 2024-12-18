//
//  MoviesScheduleMain.swift
//  MoviesSchedule
//
//  Created by Marcio Rosa on 05/12/24.
//

import MoviesScheduleDomain
import MoviesScheduleApplication
import MoviesScheduleInfrastructure
import MoviesScheduleUI
import DependenciesManager

@main
@MainActor
struct MoviesScheduleMain {
    
    static func main() {
        setupDependencies()
        MoviesScheduleUIApp.main()
    }
    
    static func setupDependencies() {
        DependenciesManager.setupDependencies([
            MoviesScheduleDomain.setupDependencies,
            MoviesScheduleApplication.setupDependencies,
            MoviesScheduleInfrastructure.setupDependencies,
            MoviesScheduleUI.setupDependencies,
        ])
    }
}
