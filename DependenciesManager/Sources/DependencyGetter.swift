//
//  DependencyGetter.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation

/** The object that can be used to retrieve the implementation of a given protocol. */
@MainActor
public protocol DependencyGetter {
    func get<T>() -> T
    func callAsFunction<T>() -> T
}

extension DependencyGetter {
    func callAsFunction<T>() -> T {
        return get()
    }
}

struct DependencyGetterImpl: DependencyGetter {
    
    private var instancesMap: [String: DependencyInstance<Any, Any>] = [:]
    private var singletons: [String: Any] = [:]
    
    init(instances: [DependencyInstance<Any, Any>]) {
        for instance in instances {
            instancesMap[String(describing: instance.protocolType)] = instance
        }
    }
    
    @MainActor func get<T>() -> T {
        let dependencyInstance = instancesMap[String(describing: T.self)]!
        switch dependencyInstance {
        case .factory(_, let factoryFunction):
            return factoryFunction(self) as! T
        case .singleton(_, let factoryFunction):
            return singletons[String(describing: T.self), default: factoryFunction(self)] as! T
        }
    }
}
