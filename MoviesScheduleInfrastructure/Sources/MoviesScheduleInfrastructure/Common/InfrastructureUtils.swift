//
//  InfrastructureUtils.swift
//  MoviesScheduleInfrastructure
//
//  Created by Marcio Rosa on 16/12/24.
//

import Foundation

public struct InfrastructureUtils: Sendable {
    
    public init() {
    }
    
    /**
     Executes a delay with the given duration, This is obviuosly a function that only exists because this project is a demo, and can be useful to
     demonstrate the parallelism of executed code when they take too long to run.
     */
    public func fakeDelay(withSeconds seconds: Double) {
        Thread.sleep(forTimeInterval: seconds)
    }
}
