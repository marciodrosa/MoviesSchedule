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
    func save() async throws
    
    /** Inserts the given sendable into the database, converting it to the appropriate managed DTO object. */
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: @Sendable @escaping (DTO, T) -> Void) async throws
    
    /** Deletes all records of the given entity. */
    func deleteAll(entity: String) async throws
    
    /** Returns all records of the given entity. This requires a converter function due a limitation of Core Data that doesn't allow entities to conform to Sendable. */
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: @Sendable @escaping (TDTO) -> T) async throws -> [T]
}

@globalActor
fileprivate actor CoreDataActor: GlobalActor {
    static var shared = CoreDataActor()
}

class CoreDataManagerImpl: CoreDataManager {
    
    @CoreDataActor
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
    
    func save() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            runInBackgroundTask { persistentContainer in
                do {
                    guard let persistentContainer else {
                        continuation.resume(throwing: RetrieveError.unreachable)
                        return
                    }
                    guard persistentContainer.viewContext.hasChanges else {
                        continuation.resume()
                        return
                    }
                    try persistentContainer.viewContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: CreateError.unknow)
                }
            }
        }
    }
    
    func create<T: Sendable, DTO>(entity: String, objects: [T], converter: @Sendable @escaping (DTO, T) -> Void) async throws(CreateError) {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                runInBackgroundTask { persistentContainer in
                    do {
                        guard let persistentContainer else {
                            continuation.resume(throwing: RetrieveError.unreachable)
                            return
                        }
                        for object in objects {
                            guard let dto = NSEntityDescription.insertNewObject(forEntityName: entity, into: persistentContainer.viewContext) as? DTO else {
                                throw CreateError.invalidData
                            }
                            converter(dto, object)
                        }
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: CreateError.unknow)
                    }
                }
            }
        } catch let error as CreateError {
            throw error
        } catch {
            throw .unknow
        }
    }
    
    func deleteAll(entity: String) async throws(DeleteError) {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                runInBackgroundTask { persistentContainer in
                    do {
                        guard let persistentContainer else {
                            continuation.resume(throwing: RetrieveError.unreachable)
                            return
                        }
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                        try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: RetrieveError.unknow)
                    }
                }
            }
        } catch let error as DeleteError {
            throw error
        } catch {
            throw .unknow
        }
    }
    
    func fetchAll<TDTO: NSFetchRequestResult, T: Sendable>(entity: String, converter: @Sendable @escaping (TDTO) -> T) async throws(RetrieveError) -> [T] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                runInBackgroundTask { persistentContainer in
                    do {
                        guard let persistentContainer else {
                            continuation.resume(throwing: RetrieveError.unreachable)
                            return
                        }
                        let fetchRequest = NSFetchRequest<TDTO>(entityName: entity)
                        let result = try persistentContainer.viewContext.fetch(fetchRequest).map(converter)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: RetrieveError.unknow)
                    }
                }
            }
        } catch let error as RetrieveError {
            throw error
        } catch {
            throw .unknow
        }
    }
    
    private func runInBackgroundTask(_ block: @Sendable @escaping @CoreDataActor (NSPersistentContainer?) -> Void) {
        DispatchQueue.global().async {
            Task {
                InfrastructureUtils().fakeDelay(withSeconds: 0.5)
                await block(await self.persistentContainer)
            }
        }
    }
}
