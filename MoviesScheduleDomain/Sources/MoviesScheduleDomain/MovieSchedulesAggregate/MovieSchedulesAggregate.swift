//
//  MovieSchedulesAggregate.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public struct MovieSchedulesAggregate: Equatable, Identifiable {
    
    public struct Schedules: Equatable, Identifiable {
        public let theater: Theater
        public let schedules: [String]
        
        public var id: Int64 {
            return theater.id
        }
    }
    
    public let movie: Movie
    private let movieSchedules: [MovieSchedules]
    private let theaters: [Theater]
    
    public var id: Int64 {
        movie.id
    }
    
    public init(movie: Movie, movieSchedules: [MovieSchedules], theaters: [Theater]) {
        self.movie = movie
        self.movieSchedules = movieSchedules
        self.theaters = theaters
    }
    
    public var theatersSchedules: [Schedules] {
        return theaters.sorted(by: { $0.name < $1.name }).map { theater in
            let schedules = movieSchedules.filter { $0.theaterId == theater.id }
                .map { $0.schedules }
                .reduce(Array<String>()) { partialResult, schedules in
                    var newResult = partialResult
                    newResult.append(contentsOf: schedules)
                    return newResult
                }.sorted()
            return Schedules(theater: theater, schedules: schedules)
        }
    }
}
