//
//  ScheduleSelectionViewModelTest.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 02/12/24.
//

import Testing
import Foundation
import MoviesScheduleDomain
import MoviesScheduleApplication

struct ScheduleSelectionViewModelTest {
    
    class MovieSchedulesAggregateServiceMock: MovieSchedulesAggregateService {
        
        var movieSchedulesAggregates: [MovieSchedulesAggregate] = []
        
        func getAllMovieSchedules() async -> [MovieSchedulesAggregate] {
            return movieSchedulesAggregates
        }
    }
    
    class ScheduleSelectionRouterMock: ScheduleSelectionRouter {
        
        var wentToSummary = false
        func goToSummary() {
            wentToSummary = true
        }
    }
    
    let movieSchedulesAggregateService = MovieSchedulesAggregateServiceMock()
    let router = ScheduleSelectionRouterMock()
    let viewModel: ScheduleSelectionViewModel
    
    init() {
        viewModel = ScheduleSelectionViewModelImpl(router: router, movieSchedulesAggregateService: movieSchedulesAggregateService)
    }

    @Test func shouldLoad() async throws {
        // given:
        let movieSchedulesAggregatesToLoad = [
            MovieSchedulesAggregate(
                movie: Movie(id: 1, title: "Punch Drunk Love", duration: TimeInterval(120)),
                movieSchedules: [
                    MovieSchedules(movieId: 1, theaterId: 10, schedules: ["14:00"])
                ],
                theaters: [
                    Theater(id: 10, name: "AMC")
                ]
            )
        ]
        movieSchedulesAggregateService.movieSchedulesAggregates = movieSchedulesAggregatesToLoad
        
        // when:
        await viewModel.load()

        // then:
        #expect(viewModel.movieSchedules == movieSchedulesAggregatesToLoad)
        #expect(!viewModel.loading)
    }

}
