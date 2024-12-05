//
//  DependenciesManager.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

public class DependenciesManager {
    
    public nonisolated(unsafe) static var getter: DependencyGetter?
    
    public static func setupDependencies(_ initializeFunctions: [() -> [DependencyInstance<Any, Any>]]) {
        var instances: [DependencyInstance<Any, Any>] = []
        for f in initializeFunctions {
            instances.append(contentsOf: f())
        }
        getter = DependencyGetterImpl(instances: instances)
    }
}
