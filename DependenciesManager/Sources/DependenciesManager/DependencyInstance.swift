//
//  DependencyInstance.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

public enum DependencyInstance<T, TImpl> {
    case singleton(T, (DependencyGetter) -> TImpl)
    case factory(T, (DependencyGetter) -> TImpl)
    case mainActorFactory(T, @MainActor (DependencyGetter) -> TImpl)
    
    //@MainActor func f(getter: DependencyGetter) -> ScheduleSelectionViewModelImpl
    
    var protocolType: T {
        switch self {
        case .singleton(let protocolType, _):
            protocolType
        case .factory(let protocolType, _):
            protocolType
        case .mainActorFactory(let protocolType, _):
            protocolType
        }
    }
}
