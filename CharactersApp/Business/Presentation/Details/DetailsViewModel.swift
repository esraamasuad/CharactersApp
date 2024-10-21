//
//  DetailsViewModel.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/19/24.
//

import Foundation
import Combine
import IHProgressHUD

class DetailsViewModel: ObservableObject {
    
    let characterRepo = CharacterRepositoryImpl()
    var cancellables = Set<AnyCancellable>()
    
    @Published var image: String = ""
    @Published var name: String = ""
    @Published var status: String = ""
    @Published var gender: String = ""
    @Published var species: String = ""
    @Published var location: String = ""
    
    var iD: Int
    var characherDetails: CharacterModel?
    
    init(characherDetails: CharacterModel?) {
        self.characherDetails = characherDetails
        self.iD = characherDetails?.id ?? 0
    }
    
    func setUp() {
        image = characherDetails?.image ?? ""
        name = characherDetails?.name ?? ""
        status = characherDetails?.status?.rawValue ?? ""
        gender = characherDetails?.gender ?? ""
        species = characherDetails?.species ?? ""
        location = characherDetails?.location?.name ?? ""
    }
    
    func getCharacterDetails() {
        IHProgressHUD.show()
        characterRepo.getCharacterDetails(id: iD).sink { completion in
            IHProgressHUD.dismiss()
            switch completion {
            case .finished: break
            case .failure(let error):
                debugPrint("Error: \(error)")
            }
        } receiveValue: { resultModel in
            self.characherDetails = resultModel
            self.setUp()
        }
        .store(in: &cancellables)
    }
}
