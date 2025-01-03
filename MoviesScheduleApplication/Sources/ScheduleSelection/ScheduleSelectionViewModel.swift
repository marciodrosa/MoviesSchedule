//
//  ScheduleSelectionViewModel.swift
//  MoviesScheduleApplication
//
//  Created by Marcio Rosa on 01/12/24.
//

import Foundation
import MoviesScheduleDomain

/** View model for the screen where the user picks the schedules. */
@MainActor
public protocol ScheduleSelectionViewModel: ObservableObject {
    var loading: Bool { get }
    var loadFailed: Bool { get }
    var movies: [Movie] { get }
    var userSchedule: UserSchedule { get }
    func theaters(byMovie: Movie) -> [Theater]
    func load() async
    func clear() async
    func isScheduleSelected(movie: Movie, theater: Theater, schedule: String) -> Bool
    func setScheduleSelected(movie: Movie, theater: Theater, schedule: String, selected: Bool)
}

public class ScheduleSelectionViewModelImpl: ScheduleSelectionViewModel {
    
    private let movieRepository: MovieRepository
    private let userScheduleRepository: UserScheduleRepository
    private let theaterRepository: TheaterRepository
    @Published public private(set) var loading: Bool = false
    @Published public private(set) var loadFailed: Bool = false
    @Published public private(set) var movies: [Movie] = []
    @Published public private(set) var userSchedule: UserSchedule = UserSchedule(items: [])
    @Published private var theaters: [Theater] = []
    private var saveTask: Task<Void, Never>?
    
    public init(movieRepository: MovieRepository, userScheduleRepository: UserScheduleRepository, theaterRepository: TheaterRepository) {
        self.movieRepository = movieRepository
        self.userScheduleRepository = userScheduleRepository
        self.theaterRepository = theaterRepository
    }
    
    public func theaters(byMovie movie: Movie) -> [Theater] {
        return theaters.filter { $0.hasMovie(movie) }.sorted { $0.name < $1.name }
    }
    
    public func load() async {
        if loading {
            return
        }
        loading = true
        loadFailed = false
        do {
            userSchedule = (try await userScheduleRepository.get()) ?? UserSchedule(items: [])
            theaters = try await theaterRepository.getAll()
            movies = (try await movieRepository.get(byIds: theaters.movieIds)).sorted { $0.title < $1.title }
        } catch {
            loadFailed = true
        }
        loading = false
    }
    
    public func clear() async {
        userSchedule = UserSchedule(items: [])
        try? await userScheduleRepository.save(userSchedule)
    }
    
    public func isScheduleSelected(movie: Movie, theater: Theater, schedule: String) -> Bool {
        userSchedule.isItemSelected(movie: movie, theater: theater, schedule: schedule)
    }
    
    public func setScheduleSelected(movie: Movie, theater: Theater, schedule: String, selected: Bool) {
        _ = userSchedule.setItemSelected(movie: movie, theater: theater, schedule: schedule, selected: selected)
        saveTask?.cancel()
        saveTask = Task {
            do {
                if Task.isCancelled {
                    return
                }
                try await userScheduleRepository.save(userSchedule)
            } catch {
            }
        }
    }
}
