//
//  ScheduleSelectionViewModel.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 01/12/24.
//

import MoviesScheduleDomain

public protocol ScheduleSelectionViewModel {
    var loading: Bool { get }
    var movieSchedules: [MovieSchedulesAggregate] { get }
    func load() async
    func viewSummary()
}

public class ScheduleSelectionViewModelImpl: ScheduleSelectionViewModel {
    
    private let router: ScheduleSelectionRouter
    private let movieSchedulesAggregateService: MovieSchedulesAggregateService
    public private(set) var loading: Bool = false
    public private(set) var movieSchedules: [MoviesScheduleDomain.MovieSchedulesAggregate] = []
    
    public init(router: ScheduleSelectionRouter, movieSchedulesAggregateService: MovieSchedulesAggregateService) {
        self.router = router
        self.movieSchedulesAggregateService = movieSchedulesAggregateService
    }
    
    public func load() async {
        if loading {
            return
        }
        loading = true
        movieSchedules = await movieSchedulesAggregateService.getAllMovieSchedules()
        loading = false
    }
    
    public func viewSummary() {
        router.goToSummary()
    }
}
