//
//  JsonResourceFileLoader.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation
import MoviesScheduleDomain

/** Provides access to the entity data declared in the resource JSON file.  */
protocol JsonResourceFileLoader: Sendable {
    
    /** Loads the objects from the JSON file of the entity, which should be located in the JsonFiles/ folder and named EntityName.json.  */
    func load<T>() async throws(RetrieveError) -> [T] where T: Decodable, T: Sendable
}

actor JsonResourceFileLoaderImpl: JsonResourceFileLoader {
    
    let bundle: Bundle
    
    init(bundle: Bundle? = nil) {
        self.bundle = bundle ?? Bundle.main
    }
    
    func load<T>() async throws(RetrieveError) -> [T] where T: Decodable, T: Sendable {
        let fileResourcePath = bundle.path(forResource: "JsonFiles/\(T.self)", ofType: "json")
        guard let fileResourcePath else {
            throw .unreachable
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: fileResourcePath)) else {
            throw .unreachable
        }
        do {
            return try JSONDecoder().decode([T].self, from: jsonData)
        } catch {
            throw .invalidData
        }
    }
}
