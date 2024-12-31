//
//  MovieDetails+Extensions.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 31/12/24.
//

import MoviesScheduleDomain
import TMDBClient

extension Movie {
    
    init(withTMDBMovieDetails tmdbMovieDetails: TMDBClient.MovieDetails) {
        self.init(id: tmdbMovieDetails.id, title: tmdbMovieDetails.title, duration: Int(truncatingIfNeeded: tmdbMovieDetails.runtime))
    }
}
