//
//  CrudErrors.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

public enum RetrieveError: Error {
    case unreachable
    case invalidData
}

public enum CreateError: Error {
    case unknow
}
