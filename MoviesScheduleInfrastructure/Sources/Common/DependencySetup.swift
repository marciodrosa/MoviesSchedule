//
//  DependencySetup.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import DependenciesManager
import MoviesScheduleDomain
import TMDBClient

public func setupDependencies() -> [DependencyInstance<Any, Any>] {
    return [
        .factory(JsonResourceFileLoader.self) { _ in JsonResourceFileLoaderImpl() },
        .factory(MovieRepository.self) { getter in MovieFromTMDBRepository(tmdbClient: getter()) },
        .factory(TheaterRepository.self) { getter in TheaterFromFileRepository(jsonResourceFileLoader: getter()) },
        .factory(UserScheduleRepository.self) { getter in UserScheduleDatabaseRepository(database: getter()) },
        .singleton(Database.self, { _ in DatabaseCoreData() }),
    ] + TMDBClient.setupDependencies()
}
