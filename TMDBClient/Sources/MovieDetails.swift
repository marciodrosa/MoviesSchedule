//
//  MovieDetails.swift
//  TMDBClient
//
//  Created by Marcio Rosa on 30/12/24.
//

public struct MovieDetails: Sendable, Identifiable, Decodable {
    public let id: Int64
    public let runtime: Int32
    public let title: String
    
    public init(id: Int64, runtime: Int32, title: String) {
        self.id = id
        self.runtime = runtime
        self.title = title
    }
}
