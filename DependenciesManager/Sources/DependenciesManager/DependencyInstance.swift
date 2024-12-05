//
//  DependencyInstance.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

public enum DependencyInstance<T, TImpl> {
    case singleton(T, (DependencyGetter) -> TImpl)
    case factory(T, (DependencyGetter) -> TImpl)
    
    var protocolType: T {
        switch self {
        case .singleton(let protocolType, let factoryFunction):
            protocolType
        case .factory(let protocolType, let factoryFunction):
            protocolType
        }
    }
}
