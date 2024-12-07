//
//  DependencySetup.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager
import MoviesScheduleDomain

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(JsonResourceFileLoader.self) { _ in JsonResourceFileLoaderImpl() },
        .factory(MovieRepository.self) { getter in MovieRepositoryFromFile(jsonResourceFileLoader: getter()) },
        .factory(TheaterRepository.self) { getter in TheaterRepositoryFromFile(jsonResourceFileLoader: getter()) },
        .factory(UserScheduleRepository.self) { getter in UserScheduleCoreDataRepository() },
    ]
}
