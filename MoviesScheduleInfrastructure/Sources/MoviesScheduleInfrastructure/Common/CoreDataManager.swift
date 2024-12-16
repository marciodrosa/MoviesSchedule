//
//  CoreDataManager.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 13/12/24.
//

import Foundation
import CoreData
import MoviesScheduleDomain

/** Object that handles storage using Core Data. */
@MainActor
protocol CoreDataManager {
    /** Saves (commits) all pending transactions. */
    func save() throws
    
    /** Inserts the given sendable into the database, converting it to the appropriate managed DTO object. */
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: (DTO, T) -> Void) throws
    
    /** Deletes all records of the given entity. */
    func deleteAll(entity: String) throws
    
    /** Returns all records of the given entity. This requires a converter function due a limitation of Core Data that doesn't allow entities to conform to Sendable. */
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: (TDTO) -> T) throws -> [T]
}


open class PersistentContainer: NSPersistentContainer, @unchecked Sendable {
}

class CoreDataManagerImpl: CoreDataManager {
    
    private lazy var persistentContainer: NSPersistentContainer? = {
        let bundle = Bundle.module
        guard let modelUrl = bundle.url(forResource: "Model", withExtension: "momd") else {
            return nil
        }
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            return nil
        }
        let container = PersistentContainer(name: "Model", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func save() throws {
        guard let persistentContainer else {
            return
        }
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        try persistentContainer.viewContext.save()
    }
    
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: (DTO, T) -> Void) throws(CreateError) {
        guard let persistentContainer else {
            throw .unreachable
        }
        for object in objects {
            if let dto = NSEntityDescription.insertNewObject(forEntityName: entity, into: persistentContainer.viewContext) as? DTO {
                converter(dto, object)
            }
        }
    }
    
    func deleteAll(entity: String) throws(DeleteError) {
        guard let persistentContainer else {
            throw .unreachable
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        } catch {
            throw .unknow
        }
    }
    
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: (TDTO) -> T) throws(RetrieveError) -> [T] {
        guard let persistentContainer else {
            throw .unreachable
        }
        let fetchRequest = NSFetchRequest<TDTO>(entityName: entity)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).map(converter)
        } catch {
            throw .unknow
        }
    }
}

