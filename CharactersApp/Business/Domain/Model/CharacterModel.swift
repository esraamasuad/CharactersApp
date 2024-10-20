//
//  File.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation


// MARK: - ResultModel
public struct ResultModel: Codable {
    let info: Info?
    let results: [CharacterModel]?
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
public struct CharacterModel: Codable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}

enum Status: String, Codable, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
