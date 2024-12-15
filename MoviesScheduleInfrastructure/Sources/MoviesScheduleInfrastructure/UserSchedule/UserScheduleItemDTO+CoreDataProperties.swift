//
//  UserScheduleItemDTO+CoreDataProperties.swift
//  MoviesSchedule
//
//  Created by Marcio Rosa on 14/12/24.
//
//

import Foundation
import CoreData
import MoviesScheduleDomain

extension UserScheduleItemDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserScheduleItemDTO> {
        return NSFetchRequest<UserScheduleItemDTO>(entityName: "UserScheduleItem")
    }

    @NSManaged public var movieId: Int64
    @NSManaged public var schedule: String?
    @NSManaged public var theaterId: Int64

    public func toUserScheduleItem() -> UserScheduleItem {
        UserScheduleItem(movieId: movieId, theaterId: theaterId, schedule: schedule ?? "")
    }
    
    public func fromUserScheduleItem(_ item: UserScheduleItem) {
        movieId = item.movieId
        theaterId = item.theaterId
        schedule = item.schedule
    }
}
