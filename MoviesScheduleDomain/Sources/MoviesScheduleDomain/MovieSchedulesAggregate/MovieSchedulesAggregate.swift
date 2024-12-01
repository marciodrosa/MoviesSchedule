//
//  MovieSchedulesAggregate.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

struct MovieSchedulesAggregate: Equatable {
    
    struct Schedules: Equatable {
        let theater: Theater
        let schedules: [String]
    }
    
    let movie: Movie
    private let movieSchedules: [MovieSchedules]
    private let theaters: [Theater]
    
    init(movie: Movie, movieSchedules: [MovieSchedules], theaters: [Theater]) {
        self.movie = movie
        self.movieSchedules = movieSchedules
        self.theaters = theaters
    }
    
    var theatersSchedules: [Schedules] {
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
