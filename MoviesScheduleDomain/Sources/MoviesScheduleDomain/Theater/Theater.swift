//
//  Theater.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

public struct Theater: Equatable, Sendable, Decodable {
    public let id: Int64
    public let name: String
    
    public init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
}
