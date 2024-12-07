//
//  ScheduleSelectionViewModel.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 01/12/24.
//

import MoviesScheduleDomain

@MainActor
public protocol ScheduleSelectionViewModel {
    var loading: Bool { get }
    var movies: [Movie] { get }
    var userSchedule: UserSchedule { get }
    func theaters(byMovie: Movie) -> [Theater]
    func load() async
    func viewSummary()
}

class ScheduleSelectionViewModelImpl: ScheduleSelectionViewModel {
    
    private let router: ScheduleSelectionRouter
    private let movieRepository: MovieRepository
    private let userScheduleRepository: UserScheduleRepository
    private let theaterRepository: TheaterRepository
    public private(set) var loading: Bool = false
    public private(set) var movies: [Movie] = []
    public private(set) var userSchedule: UserSchedule = UserSchedule(items: [])
    private var theaters: [Theater] = []
    
    public init(router: ScheduleSelectionRouter, movieRepository: MovieRepository, userScheduleRepository: UserScheduleRepository, theaterRepository: TheaterRepository) {
        self.router = router
        self.movieRepository = movieRepository
        self.userScheduleRepository = userScheduleRepository
        self.theaterRepository = theaterRepository
    }
    
    func theaters(byMovie movie: Movie) -> [Theater] {
        return theaters.filter { $0.hasMovie(movie) }.sorted { $0.name < $1.name }
    }
    
    public func load() async {
        if loading {
            return
        }
        loading = true
        movies = (try? await movieRepository.getAll())?.sorted { $0.title < $1.title } ?? []
        theaters = (try? await theaterRepository.get(byMovieIds: movies.map { $0.id })) ?? []
        loading = false
    }
    
    public func viewSummary() {
        router.goToSummary()
    }
}
