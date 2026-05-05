//
//  CharacterListVM.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import Observation
import Foundation

@MainActor
@Observable
final class CharacterListVM {
    
    enum CharacterListState {
        case idle
        case fetchFirstRemote
        
        case showList
        case noSearchResults
        
        case errorStateView // includes not internet
    }
    
    private enum FetchPageContext {
        case initial
        case next
    }
    
    private(set) var characters: [Character] = []
    private(set) var stateView: CharacterListState = .idle
    
    private var characterRepository: CharacterRepository
    private let networkMonitor: NetworkMonitoring
    private let debouncerSearch: Debouncer = .init(timeInSeconds: 0.6)
    
    @ObservationIgnored var errorFirstEvaluate: Error?
    var errorAlert: Error?
    
    var forceShowButtonLoadMore: Bool = false
    
    var isConectionReachable: Bool {
        networkMonitor.isConnected
    }
    
    // MARK: - Search filter
    
    var searchText: String = ""
    var debouncedSearchText: String = ""
    
    var isSearching: Bool { !debouncedSearchText.isEmpty }
    
    var filteredCharacters: [Character] {
        let query = debouncedSearchText
        guard !query.isEmpty else { return characters }
        
        return characters.filter { character in
            character.name.localizedCaseInsensitiveContains(query) ||
            character.species.localizedCaseInsensitiveContains(query) ||
            character.status.display.localizedCaseInsensitiveContains(query)
        }
    }
    
    func onSearchTextChanged(_ newValue: String) {
        
        if newValue.normalizedForSearch.isEmpty {
            debouncedSearchText = ""
            debouncerSearch.cancel()
            refreshSearchStateForSearch()
            return
        }
        
        debouncerSearch.run { [weak self] in
            self?.debouncedSearchText = newValue.normalizedForSearch
            self?.refreshSearchStateForSearch()
        }
    }
    
    private func refreshSearchStateForSearch() {
        guard stateView == .showList || stateView == .noSearchResults else { return }
        
        if isSearching && filteredCharacters.isEmpty {
            stateView = .noSearchResults
        } else {
            stateView = .showList
        }
    }
    
    // MARK: - About pages
    
    var isFetchingNextPage = false
    
    @ObservationIgnored private var pageInfo: PageInfo?
   
    private var nextPage: Int? {
        guard let pageInfo else {
            return characters.isEmpty ? 1 : nil
        }
        return pageInfo.nextPage
    }
    
    var currentPage: Int {
        nextPage ?? 1
    }
    
    var isPaginationAvailable: Bool {
        nextPage != nil
    }

    // MARK: - Init
    
    init(characterRepository: CharacterRepository,
         networkMonitor: NetworkMonitoring) {
        self.characterRepository = characterRepository
        self.networkMonitor = networkMonitor
    }
    
    func loadInitialValues(isRetry: Bool = false) async {
        
        stateView = .idle
        
        if isRetry {
            try? await Task.sleep(for: .seconds(0.5))
        }
        
        do {
            characters = try await characterRepository.localCharacters()
            pageInfo = try await characterRepository.localCharactersPageInfo()
            
            if characters.isEmpty {
                await fetchRemotePage(context: .initial)
            } else {
                stateView = .showList
            }
        } catch {
            errorFirstEvaluate = error
            stateView = .errorStateView
        }
    }
    
    // MARK: - Fetch data
    
    func fetchNextRemotePage() async {
        await fetchRemotePage(context: .next)
    }
    
    func updateCharacter(_ updatedCharacter: Character) {
        
        guard let index = characters.firstIndex(where: { $0 == updatedCharacter }) else { return }
        characters[index] = updatedCharacter
        
        refreshSearchStateForSearch()
    }
    
    private func fetchRemotePage(context: FetchPageContext) async {
        
        guard let nextPage else { return }
        guard !isFetchingNextPage else { return }
        
        isFetchingNextPage = true
        forceShowButtonLoadMore = false
        
        switch context {
        case .initial:
            stateView = .fetchFirstRemote
            
        case .next:
            break
        }
        
        defer {
            isFetchingNextPage = false
        }
        
        do {
            let pageResults = try await characterRepository.fetchCharacter(page: nextPage)
            
            switch context {
            case .initial:
                characters = pageResults.items
                stateView = .showList
                
            case .next:
                let savedIDs = Set(characters.map(\.id))
                let newItems = pageResults.items.filter { !savedIDs.contains($0.id) }
                characters.append(contentsOf: newItems)
            }
            
            pageInfo = pageResults.pageInfo
            
        } catch {
            switch context {
                
            case .initial:
                errorFirstEvaluate = error
                stateView = .errorStateView
                
            case .next:
                forceShowButtonLoadMore = true
                errorAlert = error
            }
        }
    }
}
