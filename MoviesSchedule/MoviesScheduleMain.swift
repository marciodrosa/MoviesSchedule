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
struct MoviesScheduleMain {
    
    static func main() {
        setupDependencies()
        MoviesScheduleApp.main()
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
