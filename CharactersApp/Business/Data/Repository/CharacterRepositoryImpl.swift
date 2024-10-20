//
//  CharacterRepositoryImpl.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Combine

class CharacterRepositoryImpl: CharacterRepository {
    
    func getCharacters(status: String, page: Int) -> AnyPublisher<ResultModel?, APIError> {
        CharacterRouter.allCharacters(status, page).fetch()
    }
    
    func getCharacterDetails(id: Int) -> AnyPublisher<CharacterModel?, APIError> {
        CharacterRouter.singleCharacter(id: id).fetch()
    }
}

