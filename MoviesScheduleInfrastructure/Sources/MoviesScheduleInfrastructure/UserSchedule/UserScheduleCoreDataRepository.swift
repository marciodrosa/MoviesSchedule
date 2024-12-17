//
//  UserScheduleRepositoryCoreData.swift
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

struct UserScheduleCoreDataRepository: UserScheduleRepository {
    
    private let coreDataManager: CoreDataManager
    
    private static let itemEntityName = "UserScheduleItem"
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func get() async throws(RetrieveError) -> UserSchedule? {
        do {
            let items: [UserScheduleItem] = try await coreDataManager.fetchAll(
                entity: UserScheduleCoreDataRepository.itemEntityName,
                converter: toUserScheduleItemConverter
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
            try await coreDataManager.deleteAll(entity: UserScheduleCoreDataRepository.itemEntityName)
            try await coreDataManager.create(entity: UserScheduleCoreDataRepository.itemEntityName, objects: userSchedule.items, converter: fromUserScheduleItemConverter)
            try await coreDataManager.save()
        } catch {
            throw CreateError.unknow
        }
    }
    
    func deleteAll() async throws(DeleteError) {
        do {
            try await coreDataManager.deleteAll(entity: UserScheduleCoreDataRepository.itemEntityName)
            try await coreDataManager.save()
        } catch {
            throw DeleteError.unknow
        }
    }
}
