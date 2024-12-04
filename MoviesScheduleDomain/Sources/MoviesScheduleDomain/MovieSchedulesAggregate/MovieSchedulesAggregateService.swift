//
//  MovieSchedulesAggregateRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public protocol MovieSchedulesAggregateService: Sendable {
    func getAllMovieSchedules() async throws(RetrieveError) -> [MovieSchedulesAggregate]
}

public final class MovieSchedulesAggregateServiceImpl: MovieSchedulesAggregateService {
    private let movieRepository: MovieRepository
    private let movieSchedulesRepository: MovieSchedulesRepository
    private let theaterRepository: TheaterRepository
    
    init(movieRepository: MovieRepository, movieSchedulesRepository: MovieSchedulesRepository, theaterRepository: TheaterRepository) {
        self.movieRepository = movieRepository
        self.movieSchedulesRepository = movieSchedulesRepository
        self.theaterRepository = theaterRepository
    }
    
    public func getAllMovieSchedules() async throws(RetrieveError) -> [MovieSchedulesAggregate] {
        do {
            var result: [MovieSchedulesAggregate] = []
            let movies = try await movieRepository.getAll()
            for movie in movies {
                let movieSchedules = try await movieSchedulesRepository.get(byMovieId: movie.id)
                let theaters = try await theaterRepository.get(byIds: movieSchedules.map {$0.theaterId})
                result.append(MovieSchedulesAggregate(movie: movie, movieSchedules: movieSchedules, theaters: theaters))
            }
            return result
        } catch {
            throw error
        }
    }
}
