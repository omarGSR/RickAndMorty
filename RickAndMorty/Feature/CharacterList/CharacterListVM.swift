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
        
        case errorStateView // includes not internet
    }
    
    var characters: [Character] = []
    var stateView: CharacterListState = .idle
    
    @ObservationIgnored
    var errorFirstEvaluate: Error?
    
    private var characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
    
    func loadInitialValues(isRetry: Bool = false) async {
        
        stateView = .idle
        
        if isRetry {
            try? await Task.sleep(for: .seconds(0.5))
        }
        
        do {
            characters = try await characterRepository.localCharacters()
            
            if characters.isEmpty {
                await fetchFirstRemotePage()
            } else {
                stateView = .showList
            }
        } catch {
            errorFirstEvaluate = error
            stateView = .errorStateView
        }
    }
    
    private func fetchFirstRemotePage() async {
        do {
            stateView = .fetchFirstRemote
            let pageResults = try await characterRepository.fetchCharacter(page: 1)
            characters = pageResults.items
            stateView = .showList
        } catch {
            errorFirstEvaluate = error
            stateView = .errorStateView
        }
    }
}
