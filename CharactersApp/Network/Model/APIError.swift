//
//  APIError.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation


public enum APIError: Error, LocalizedError {
    
    case unknown, apiError(message: String?, statusCode: Int?), decoding(message: String?), invalidURL

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Server Error"
        case .apiError(let message, _ ):
            return message ?? "Server Error"
        case .decoding(let message):
            return message ?? "Decoding Error"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
