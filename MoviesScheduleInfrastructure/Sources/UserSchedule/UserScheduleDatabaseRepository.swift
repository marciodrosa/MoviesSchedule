//
//  UserScheduleDatabaseRepository.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 06/12/24.
//

import CoreData
import MoviesScheduleDomain

fileprivate func toUserScheduleItemConverter(dto: UserScheduleItemDTO) -> UserScheduleItem {
    dto.toUserScheduleItem()
}

fileprivate func fromUserScheduleItemConverter(dto: UserScheduleItemDTO, item: UserScheduleItem) {
    dto.fromUserScheduleItem(item)
}

struct UserScheduleDatabaseRepository: UserScheduleRepository {
    
    private let database: Database
    
    private let itemEntityName = "UserScheduleItem"
    
    init(database: Database) {
        self.database = database
    }
    
    func get() async throws(CrudError) -> UserSchedule? {
        return try await database.execute { dbFunctions in
            let items = try dbFunctions.retrieveAll(entity: itemEntityName, converter: toUserScheduleItemConverter)
            guard items.count > 0 else {
                return nil
            }
            return UserSchedule(items: items)
        }
    }
    
    func save(_ userSchedule: UserSchedule) async throws(CrudError) {
        try await database.execute { dbFunctions in
            try dbFunctions.deleteAll(entity: itemEntityName)
            try dbFunctions.create(entity: itemEntityName, objects: userSchedule.items, converter: fromUserScheduleItemConverter)
            try dbFunctions.commit()
        }
    }
    
    func deleteAll() async throws(CrudError) {
        try await database.execute { dbFunctions in
            try dbFunctions.deleteAll(entity: itemEntityName)
            try dbFunctions.commit()
        }
    }
}
