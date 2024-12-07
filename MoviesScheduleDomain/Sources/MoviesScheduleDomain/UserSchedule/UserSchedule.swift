//
//  UserSchedule.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

/** Entity and aggregate root that contains the selected schedules by the user. */
public struct UserSchedule: Equatable, Sendable {
    
    private var items: [UserScheduleItem]
    
    public init(items: [UserScheduleItem]) {
        self.items = items
    }
    
    /** Toggle the selection of the given schedule, returning true if it ends being selected of false if unselected. */
    public mutating func toggleScheduleItem(movie: Movie, theater: Theater, schedule: String) -> Bool {
        let item = UserScheduleItem(movieId: movie.id, theaterId: theater.id, schedule: schedule)
        if let oldSelectionIndex = items.firstIndex(of: item) {
            items.remove(at: oldSelectionIndex)
            return false
        } else {
            items.append(item)
            return true
        }
    }
    
    public func isItemSelected(movie: Movie, theater: Theater, schedule: String) -> Bool {
        items.contains { $0 == UserScheduleItem(movieId: movie.id, theaterId: theater.id, schedule: schedule) }
    }
    
}
