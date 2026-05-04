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
    
    private enum FetchPageContext {
        case initial
        case next
    }
    
    var characters: [Character] = []
    var stateView: CharacterListState = .idle
    
    private var characterRepository: CharacterRepository
    private let networkMonitor: NetworkMonitoring
    
    @ObservationIgnored var errorFirstEvaluate: Error?
    var errorAlert: Error?
    
    var forceShowButtonLoadMore: Bool = false
    
    var isConectionReachable: Bool {
        networkMonitor.isConnected
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
