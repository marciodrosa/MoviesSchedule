//
//  MoviesScheduleUIApp.swift
//  MoviesSchedule
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI
import SwiftData
import DependenciesManager

public struct MoviesScheduleUIApp: App {
    
    public init() {
    }
    
    public var body: some Scene {
        WindowGroup {
            homeView
        }
    }
    
    public var homeView: AnyView {
        let factory: HomeViewFactory = DependenciesManager.getter!.mainActorGet()
        return AnyView(factory.createView())
    }
}
