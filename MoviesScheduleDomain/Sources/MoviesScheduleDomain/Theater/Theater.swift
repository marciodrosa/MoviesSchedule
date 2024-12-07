//
//  Theater.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 28/11/24.
//

/** Entity and aggregate root that contains theater info and its movie schedules. */
public struct Theater: Equatable, Sendable, Decodable, Identifiable {
    public let id: Int64
    public let name: String
    public var movieSchedules: [MovieSchedules] = []
    
    public init(id: Int64, name: String, movieSchedules: [MovieSchedules] = []) {
        self.id = id
        self.name = name
        self.movieSchedules = movieSchedules
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case movieSchedules
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.movieSchedules = (try? container.decode([MovieSchedules].self, forKey: .movieSchedules)) ?? []
    }
    
    public func schedules(byMovie movie: Movie) -> [String] {
        movieSchedules.first { $0.movieId == movie.id }?.schedules ?? []
    }
    
    public func hasMovie(_ movie: Movie) -> Bool {
        return movieSchedules.contains { $0.movieId == movie.id }
    }
}
