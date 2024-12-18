//
//  DependencyInstance.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

/** The type of dependency injection of an object. */
public enum DependencyInstance<T, TImpl> {
    /** Uses always the same instance when it is requested, like a singleton.. */
    case singleton(T, @MainActor (DependencyGetter) -> TImpl)
    
    /** Creates a new instance every time it is requested.  */
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
