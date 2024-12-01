//
//  MovieSchedulesRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

protocol MovieSchedulesRepository {
    func get(byMovieId movieId: Int64) async -> [MovieSchedules]
}
