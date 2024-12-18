//
//  Database.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 13/12/24.
//

import Foundation
import CoreData
import MoviesScheduleDomain

/** Global actor used to run database operations. */
@globalActor
actor DatabaseActor: GlobalActor {
    static var shared = DatabaseActor()
}

/** Interface for common CRUD operations to be made in a database. */
@DatabaseActor
protocol DatabaseFunctions {
    /** Saves (commits) all pending transactions. */
    func commit() throws(CrudError)
    
    /** Inserts the given sendable into the database, converting it to the appropriate managed DTO object. */
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: @Sendable @escaping (DTO, T) -> Void) throws(CrudError)
    
    /** Deletes all records of the given entity. */
    func deleteAll(entity: String) throws(CrudError)
    
    /** Returns all records of the given entity. This requires a converter function due a limitation of Core Data that doesn't allow entities to conform to Sendable. */
    func retrieveAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: @Sendable @escaping (TDTO) -> T) throws(CrudError) -> [T]
}

/** Represents the app's database. */
@MainActor
protocol Database {
    
    /** Executes the operations with the given DatabaseFunctions in parallel. */
    func execute<T: Sendable>(_ block: @escaping @Sendable @DatabaseActor (any DatabaseFunctions) throws -> T) async throws(CrudError) -> T
}

/** DatabaseFunctions implementation for CoreData database. */
fileprivate class DatabaseFunctionsCoreData: DatabaseFunctions {
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func commit() throws(CrudError) {
        guard persistentContainer.viewContext.hasChanges else {
            return
        }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            throw .unknow
        }
    }
    
    func create<T, DTO>(entity: String, objects: [T], converter: @escaping @Sendable (DTO, T) -> Void) throws(CrudError) where T : Sendable {
        for object in objects {
            guard let dto = NSEntityDescription.insertNewObject(forEntityName: entity, into: persistentContainer.viewContext) as? DTO else {
                throw .invalidData
            }
            converter(dto, object)
        }
    }
    
    func deleteAll(entity: String) throws(CrudError) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        } catch {
            throw .unknow
        }
    }
    
    func retrieveAll<TDTO, T>(entity: String, converter: @escaping @Sendable (TDTO) -> T) throws(CrudError) -> [T] where TDTO : NSFetchRequestResult, T : Sendable {
        do {
            let fetchRequest = NSFetchRequest<TDTO>(entityName: entity)
            return try persistentContainer.viewContext.fetch(fetchRequest).map(converter)
        } catch {
            throw .unknow
        }
    }
}

/** Database implementation that uses CoreData. */
class DatabaseCoreData: Database {
    
    @DatabaseActor
    private lazy var persistentContainer: NSPersistentContainer? = {
        let bundle = Bundle.module
        guard let modelUrl = bundle.url(forResource: "Model", withExtension: "momd") else {
            return nil
        }
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            return nil
        }
        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func execute<T: Sendable>(_ block: @escaping @Sendable @DatabaseActor (any DatabaseFunctions) throws -> T) async throws(CrudError) -> T {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().async {
                    Task {
                        guard let container = await self.persistentContainer else {
                            continuation.resume(throwing: CrudError.unreachable)
                            return
                        }
                        InfrastructureUtils().fakeDelay(withSeconds: 0.5)
                        let databaseFunctions = await DatabaseFunctionsCoreData(persistentContainer: container)
                        do {
                            let result = try await block(databaseFunctions)
                            continuation.resume(returning: result)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        } catch let error as CrudError {
            throw error
        } catch {
            throw .unknow
        }
    }
}
