//
//  UserScheduleRepositoryCoreData.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 06/12/24.
//

import CoreData
import MoviesScheduleDomain

struct UserScheduleCoreDataRepository: UserScheduleRepository {
    
    private let coreDataManager: CoreDataManager
    
    private static let entityName = "UserScheduleItem"
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func get() async throws(RetrieveError) -> UserSchedule? {
        do {
            let converter: (UserScheduleItemDTO) -> UserScheduleItem = { $0.toUserScheduleItem() }
            let items: [UserScheduleItem] = try coreDataManager.fetchAll(
                entity: UserScheduleCoreDataRepository.entityName,
                converter: converter
            )
            guard items.count > 0 else {
                return nil
            }
            return UserSchedule(items: items)
        } catch {
            throw RetrieveError.unknow
        }
    }
    
    func save(_ userSchedule: UserSchedule) async throws(CreateError) {
        do {
            try await deleteAll()
            let converter: (UserScheduleItemDTO, UserScheduleItem) -> Void = { $0.fromUserScheduleItem($1) }
            try coreDataManager.create(entity: UserScheduleCoreDataRepository.entityName, objects: userSchedule.items, converter: converter)
        } catch {
            throw CreateError.unknow
        }
    }
    
    func deleteAll() async throws(DeleteError) {
        do {
            try coreDataManager.deleteAll(entity: UserScheduleCoreDataRepository.entityName)
            try coreDataManager.save()
        } catch {
            throw DeleteError.unknow
        }
    }
}
