//
//  MovieSchedulesAggregate.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

/** An aggregate object that contains a movie as root and the related theaters, schedules and user selections.  */
public struct MovieSchedulesAggregate: Equatable, Identifiable, Copyable, Sendable {
    
    public struct SchedulesByTheater: Equatable, Identifiable {
        
        public struct UserSchedule: Equatable {
            let schedule: String
            let selected: Bool
        }
        
        public let theater: Theater
        public let schedules: [UserSchedule]
        
        public var id: Int64 {
            return theater.id
        }
    }

    public let movie: Movie
    private let movieSchedules: [MovieSchedules]
    private let theaters: [Theater]
    private var userSelections: [UserSelection]
    
    public var id: Int64 {
        movie.id
    }
    
    public init(movie: Movie, movieSchedules: [MovieSchedules], theaters: [Theater], userSelections: [UserSelection]) {
        self.movie = movie
        self.movieSchedules = movieSchedules
        self.theaters = theaters
        self.userSelections = userSelections
    }
    
    /** Returns an organized and sorted list of all schedules and theaters for this movie. */
    public var theatersSchedules: [SchedulesByTheater] {
        return theaters.sorted(by: { $0.name < $1.name }).map { theater in
            let schedules = movieSchedules.filter { $0.theaterId == theater.id }
                .map { $0.schedules }
                .reduce(Array<String>()) { partialResult, schedules in
                    var newResult = partialResult
                    newResult.append(contentsOf: schedules)
                    return newResult
                }
                .sorted()
                .map { schedule in
                    SchedulesByTheater.UserSchedule(
                        schedule: schedule,
                        selected: userSelections.contains {
                            $0 == UserSelection(movieId: movie.id, theaterId: theater.id, schedule: schedule)
                        }
                    )
                }
            return SchedulesByTheater(theater: theater, schedules: schedules)
        }
    }
    
    /** Toggles the user selection for this movie in the given theater and schedule, returning the final state of the selection (selected or unselected). */
    public mutating func toggleUserSelection(theaterId: Int64, schedule: String) -> Bool {
        guard movieSchedules.filter({ $0.theaterId == theaterId }).contains(where: { $0.schedules.contains(where: { $0 == schedule }) }) else {
            return false
        }
        let userSelection = UserSelection(movieId: movie.id, theaterId: theaterId, schedule: schedule)
        if let oldSelectionIndex = userSelections.firstIndex(of: userSelection) {
            userSelections.remove(at: oldSelectionIndex)
            return false
        } else {
            userSelections.append(userSelection)
            return true
        }
    }
}
