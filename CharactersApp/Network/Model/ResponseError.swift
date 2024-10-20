//
//  ResponseError.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation

public enum ResponseError: LocalizedError {
    case errorResponse(message: String)
    case decoding
    case network(message: String)
    case unauthenticated
    case offline
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .errorResponse(let message):
            return message
        case .decoding:
            return "Sorry, unexpected error occured. Will fix this so soon"
        case .network(let message):
            return message
        case .unauthenticated:
            return "Please log in to continue"
        case .offline:
            return "Please connect to the internet"
        case .unknown:
            return "Sorry, unnkown error occured. Please try again in a while"
        }
    }
}
