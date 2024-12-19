//
//  JsonResourceFileLoader.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation
import MoviesScheduleDomain

/** Provides access to the entity data declared in the resource JSON file.  */
@MainActor
protocol JsonResourceFileLoader {
    
    /** Loads the objects from the JSON file of the entity, which should be located in the JsonFiles/ folder and named EntityName.json.  */
    func load<T>() async throws(CrudError) -> [T] where T: Decodable, T: Sendable
}

struct JsonResourceFileLoaderImpl: JsonResourceFileLoader {
    
    let bundle: Bundle
    
    init(bundle: Bundle? = nil) {
        self.bundle = bundle ?? Bundle.module
    }
    
    func load<T>() async throws(CrudError) -> [T] where T: Decodable, T: Sendable {
        let fileResourcePath = bundle.path(forResource: "JsonFiles/\(T.self)", ofType: "json")
        guard let fileResourcePath else {
            throw .unreachable
        }
        do {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().async {
                    InfrastructureUtils().fakeDelay(withSeconds: 0.5)
                    guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: fileResourcePath)) else {
                        continuation.resume(throwing: CrudError.unreachable)
                        return;
                    }
                    do {
                        let decodedData = try JSONDecoder().decode([T].self, from: jsonData)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: CrudError.invalidData)
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
