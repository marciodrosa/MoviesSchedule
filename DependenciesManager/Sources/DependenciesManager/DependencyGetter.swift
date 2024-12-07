//
//  DependencyGetter.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

import Foundation

public protocol DependencyGetter {
    func get<T>() -> T
    @MainActor func mainActorGet<T>() -> T
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
    
    func get<T>() -> T {
        let dependencyInstance = instancesMap[String(describing: T.self)]!
        switch dependencyInstance {
        case .singleton(_, let factoryFunction):
            return singletons[String(describing: T.self), default: factoryFunction(self)] as! T
        case .factory(_, let factoryFunction):
            return factoryFunction(self) as! T
        case .mainActorFactory(_, _):
            fatalError("Must call mainActorGet to retrieve an instance from an mainActorFactory.")
        }
    }
    
    @MainActor func mainActorGet<T>() -> T {
        let dependencyInstance = instancesMap[String(describing: T.self)]!
        switch dependencyInstance {
        case .mainActorFactory(_, let factoryFunction):
            return factoryFunction(self) as! T
        default:
            fatalError("Must call get instead of mainActorGet to retrieve an instance that is not from an mainActorFactory.")
        }
    }
}
