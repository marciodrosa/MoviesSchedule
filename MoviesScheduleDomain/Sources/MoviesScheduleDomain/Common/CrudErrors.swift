//
//  CrudErrors.swift
//  MoviesScheduleDomain
//
//  Created by Marcio Rosa on 04/12/24.
//

/** Common error that may be throw in CRUD operations. */
public enum CrudError: Error {
    /** The data is unreachable for read or write. For example, lack of internet connection, or could not reach the database or filesystem etc. */
    case unreachable
    
    /** The data being read or write is invalid, like missing or wrong fields, malformatted and so on. */
    case invalidData
    
    /** Unknown generic error. */
    case unknow
}
