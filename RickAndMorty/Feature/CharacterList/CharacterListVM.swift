//
//  CharacterListVM.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import Observation

@MainActor
@Observable
final class CharacterListVM {
    
    enum CharacterListState {
        case idle
        case fetchFirstRemote
        case showList
        case notInternet
    }
    
    var characters: [Character] = []
    var stateView: CharacterListState = .idle
    
    private var characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
    
    func loadInitialValues() async {

        do {
            characters = try await characterRepository.localCharacters()
            
            if characters.isEmpty {
                await fetchFirstRemotePage()
            } else {
                stateView = .showList
            }
        } catch {
            print(error)
        }
    }
    
    private func fetchFirstRemotePage() async {
        do {
            stateView = .fetchFirstRemote
            let pageResults = try await characterRepository.fetchCharacter(page: 1)
            characters = pageResults.items
            stateView = .showList
        } catch {
            print(error)
        }
    }
}
