//
//  HomeViewModel.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/19/24.
//

import Foundation
import IHProgressHUD
import Combine

class HomeViewModel: ObservableObject {
    
    let characterRepo = CharacterRepositoryImpl()
    var cancellables = Set<AnyCancellable>()
    
    @Published var filterList: [Status] = Status.allCases
    @Published var charactersList: [CharacterModel] = []
    
    var page: Int = 0
    var totalPages = 0
    var status: String = ""
    
    var isLoading: Bool = false
    var pullToRefresh: Bool = false
    
    /// Refersh
    func refresh() {
        pullToRefresh = true
        self.status = ""
        self.charactersList = []
        page = 0
        getCharacters()
    }
    
    /// Reset Filter
    func resetFilter(index: Int) {
        self.status = filterList[index].rawValue
        self.charactersList = []
        page = 0
        getCharacters()
    }
    
    /// get All Characters [status + page]
    func getCharacters() {
        guard !isLoading else { return }
        
        if (page == 0 && !pullToRefresh) { IHProgressHUD.show() }
        
        page += 1
        isLoading = true
        
        characterRepo.getCharacters(status: status, page: page).sink { completion in
            IHProgressHUD.dismiss()
            self.isLoading = false
            self.pullToRefresh = false
            
            switch completion {
            case .finished: break
            case .failure(let error): print("Error: \(error)")
            }
        } receiveValue: { resultModel in
            self.totalPages = resultModel?.info?.pages ?? 0
            self.charactersList.append(contentsOf: resultModel?.results ?? [])
        }
        .store(in: &cancellables)
    }
}
