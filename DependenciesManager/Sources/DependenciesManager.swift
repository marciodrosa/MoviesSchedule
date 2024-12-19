//
//  DependenciesManager.swift
//  DependenciesManager
//
//  Created by Marcio Rosa on 04/12/24.
//

/** The main class responsible to manage the dependency injection. */
@MainActor
public class DependenciesManager {
    
    /** The object that can be used to retrieve dependencies implementations. */
    public static var getter: DependencyGetter?
    
    /** Must be called to set all the implementations of dependencies. */
    public static func setupDependencies(_ initializeFunctions: [() -> [DependencyInstance<Any, Any>]]) {
        var instances: [DependencyInstance<Any, Any>] = []
        for f in initializeFunctions {
            instances.append(contentsOf: f())
        }
        getter = DependencyGetterImpl(instances: instances)
    }
}
