//
//  CharacterRouter.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//


import Alamofire

enum CharacterRouter: RequestBuilder {
    
    case allCharacters(_ status:String, _ page:Int)
    case singleCharacter(id:Int)
    
    internal var path: String {
        switch self {
        case .allCharacters(_, _):
            return "/api/character"
        case .singleCharacter(let id):
            return "/api/character/\(id)"
        }
    }
    
    internal var parameters: Parameters? {
        switch self {
        case .allCharacters(let status, let page):
            let params: [String: Any] = ["status": status,
                                         "page": page]
            return params
        default:
            return nil
        }
    }
    
    internal var method: HTTPMethod {
        switch self {
        case .allCharacters(_, _), .singleCharacter(_):
            return .get
        }
    }
}
