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
    
    /** The data was reachable, but it was not allowed to access it. */
    case forbidden
    
    /** A specific data could not be found.  */
    case notFound
    
    /** The data being read or write is invalid, like missing or wrong fields, malformatted and so on. */
    case invalidData
    
    /** The input (like parameters) passed to retrieve the data is invalid or malformatted. */
    case invalidInput
    
    /** Unknown generic error. */
    case unknow
    
    /** An unknown error happened, but not here. For example, an unknown error in the server (500). */
    case unknownExternalError
}
