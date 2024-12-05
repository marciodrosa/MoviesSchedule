//
//  ScheduleSelectionViewModel.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 01/12/24.
//

import MoviesScheduleDomain

public protocol ScheduleSelectionViewModel: Sendable {
    var loading: Bool { get async }
    var movieSchedules: [MovieSchedulesAggregate] { get async }
    func load() async
    func viewSummary() async
}

actor ScheduleSelectionViewModelImpl: ScheduleSelectionViewModel {
    
    private let router: ScheduleSelectionRouter
    private let movieSchedulesAggregateService: MovieSchedulesAggregateService
    public private(set) var loading: Bool = false
    public private(set) var movieSchedules: [MovieSchedulesAggregate] = []
    
    public init(router: ScheduleSelectionRouter, movieSchedulesAggregateService: MovieSchedulesAggregateService) {
        self.router = router
        self.movieSchedulesAggregateService = movieSchedulesAggregateService
    }
    
    public func load() async {
        if loading {
            return
        }
        loading = true
        let service = movieSchedulesAggregateService // we neet to set to a local var to avoid a Swift 6 bug
        movieSchedules = (try? await service.getAllMovieSchedules()) ?? []
        loading = false
    }
    
    public func viewSummary() async {
        await router.goToSummary()
    }
}
