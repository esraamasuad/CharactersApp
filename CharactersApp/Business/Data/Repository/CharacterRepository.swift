//
//  CharacterRepository.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Combine

public protocol CharacterRepository {
    func getCharacters(status: String, page: Int) -> AnyPublisher<ResultModel?, APIError>
    func getCharacterDetails(id: Int) -> AnyPublisher<CharacterModel?, APIError>
}
