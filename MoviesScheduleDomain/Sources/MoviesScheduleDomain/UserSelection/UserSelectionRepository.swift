//
//  UserSelectionRepository.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 05/12/24.
//

public protocol UserSelectionRepository: Sendable {
    func get(byMovieId movieId: Int64) async throws(RetrieveError) -> [UserSelection]
}
