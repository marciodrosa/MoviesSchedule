//
//  CoreDataManager.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 13/12/24.
//

import CoreData

/** Object that handles storage using Core Data. */
protocol CoreDataManager: Actor {
    /** Saves (commits) all pending transactions. */
    func save() throws
    
    /** Inserts the given sendable into the database, converting it to the appropriate managed DTO object. */
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: (DTO, T) -> Void) throws
    
    /** Deletes all records of the given entity. */
    func deleteAll(entity: String) throws
    
    /** Returns all records of the given entity. This requires a converter function due a limitation of Core Data that doesn't allow entities to conform to Sendable. */
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: (TDTO) -> T) throws -> [T]
}

actor CoreDataManagerImpl: CoreDataManager {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func save() throws {
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        try persistentContainer.viewContext.save()
    }
    
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: (DTO, T) -> Void) {
        for object in objects {
            if let dto = NSEntityDescription.insertNewObject(forEntityName: entity, into: persistentContainer.viewContext) as? DTO {
                converter(dto, object)
            }
        }
    }
    
    func deleteAll(entity: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        }
    }
    
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: (TDTO) -> T) throws -> [T] {
        let fetchRequest = NSFetchRequest<TDTO>(entityName: entity)
        return try persistentContainer.viewContext.fetch(fetchRequest).map(converter)
    }
}

