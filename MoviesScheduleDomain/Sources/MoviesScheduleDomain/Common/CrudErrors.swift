//
//  CrudErrors.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

public enum RetrieveError: Error {
    case unreachable
    case invalidData
    case unknow
}

public enum CreateError: Error {
    case unreachable
    case invalidData
    case unknow
}

public enum DeleteError: Error {
    case unreachable
    case unknow
}
