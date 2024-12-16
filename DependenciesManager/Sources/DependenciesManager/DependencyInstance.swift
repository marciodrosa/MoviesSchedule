//
//  DependencyInstance.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

public enum DependencyInstance<T, TImpl> {
    case singleton(T, @MainActor (DependencyGetter) -> TImpl)
    case factory(T, @MainActor (DependencyGetter) -> TImpl)
    
    var protocolType: T {
        switch self {
        case .singleton(let protocolType, _):
            protocolType
        case .factory(let protocolType, _):
            protocolType
        }
    }
}
