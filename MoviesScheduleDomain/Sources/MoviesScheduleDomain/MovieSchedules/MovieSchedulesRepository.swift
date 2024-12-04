//
//  MovieSchedulesRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public protocol MovieSchedulesRepository: Sendable {
    func get(byMovieId movieId: Int64) async throws(RetrieveError) -> [MovieSchedules]
}
