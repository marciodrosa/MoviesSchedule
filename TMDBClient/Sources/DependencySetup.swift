//
//  DependencySetup.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 31/12/24.
//

import DependenciesManager

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .singleton(ApiClient.self, { _ in ApiClientImpl() })
    ]
}
