//
//  MoviesScheduleUIApp.swift
//  MoviesSchedule
//
//  Created by Marcio Rosa on 12/12/24.
//

import SwiftUI
import SwiftData
import DependenciesManager

/** The App class - basically the UI entry point. */
public struct MoviesScheduleUIApp: App {
    
    public init() {
    }
    
    public var body: some Scene {
        WindowGroup {
            homeView
        }
    }
    
    public var homeView: AnyView {
        let factory: HomeViewFactory = DependenciesManager.getter!.get()
        return AnyView(factory.createView())
    }
}
