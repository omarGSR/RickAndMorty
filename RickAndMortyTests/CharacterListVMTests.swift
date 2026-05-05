//
//  CharacterListVMTests.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class CharacterListVMTests: XCTestCase {
    
    func testLoadInitialValuesWhenLocalCharactersExistShowsLocalList() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([.mock(id: 1)])
        repository.localCharactersPageInfoResult = .success(.mock(currentPage: 1, nextPage: 2))
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        
        XCTAssertEqual(sut.characters.map(\.id), [1])
        XCTAssertState(sut.stateView, is: .showList)
        XCTAssertEqual(repository.localCharactersCallCount, 1)
        XCTAssertEqual(repository.localCharactersPageInfoCallCount, 1)
        XCTAssertTrue(repository.receivedPages.isEmpty)
        XCTAssertTrue(sut.isPaginationAvailable)
        XCTAssertEqual(sut.currentPage, 2)
    }
    
    func testLoadInitialValuesWhenLocalCharactersAreEmptyFetchesFirstRemotePage() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([])
        repository.localCharactersPageInfoResult = .success(nil)
        repository.fetchCharacterResult = .success(
            PageResults(
                pageInfo: .mock(currentPage: 1, nextPage: 2),
                items: [.mock(id: 1), .mock(id: 2)]
            )
        )
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        
        XCTAssertEqual(repository.receivedPages, [1])
        XCTAssertEqual(sut.characters.map(\.id), [1, 2])
        XCTAssertState(sut.stateView, is: .showList)
        XCTAssertFalse(sut.isFetchingNextPage)
        XCTAssertTrue(sut.isPaginationAvailable)
        XCTAssertEqual(sut.currentPage, 2)
    }
    
    func testFetchNextRemotePageAppendsOnlyNewCharacters() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([.mock(id: 1), .mock(id: 2)])
        repository.localCharactersPageInfoResult = .success(.mock(currentPage: 1, nextPage: 2))
        repository.fetchCharacterResult = .success(
            PageResults(
                pageInfo: .mock(currentPage: 2, nextPage: 3, previousPage: 1),
                items: [.mock(id: 2), .mock(id: 3)]
            )
        )
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await sut.fetchNextRemotePage()
        
        XCTAssertEqual(repository.receivedPages, [2])
        XCTAssertEqual(sut.characters.map(\.id), [1, 2, 3])
        XCTAssertState(sut.stateView, is: .showList)
        XCTAssertFalse(sut.forceShowButtonLoadMore)
        XCTAssertTrue(sut.isPaginationAvailable)
        XCTAssertEqual(sut.currentPage, 3)
    }
    
    func testFetchNextRemotePageWhenRepositoryFailsKeepsListAndShowsLoadMoreButton() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([.mock(id: 1)])
        repository.localCharactersPageInfoResult = .success(.mock(currentPage: 1, nextPage: 2))
        repository.fetchCharacterResult = .failure(RepositoryTestError.remoteFailure)
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await sut.fetchNextRemotePage()
        
        XCTAssertEqual(repository.receivedPages, [2])
        XCTAssertEqual(sut.characters.map(\.id), [1])
        XCTAssertState(sut.stateView, is: .showList)
        XCTAssertTrue(sut.forceShowButtonLoadMore)
        XCTAssertEqual(sut.errorAlert as? RepositoryTestError, .remoteFailure)
        XCTAssertFalse(sut.isFetchingNextPage)
    }
    
    func testLoadInitialValuesWhenLocalRepositoryFailsShowsErrorState() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .failure(RepositoryTestError.remoteFailure)
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        
        XCTAssertState(sut.stateView, is: .errorStateView)
        XCTAssertEqual(sut.errorFirstEvaluate as? RepositoryTestError, .remoteFailure)
        XCTAssertTrue(repository.receivedPages.isEmpty)
    }
    
    func testFilteredCharactersWhenSearchTextIsEmptyReturnsAllCharacters() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([.mock(id: 1), .mock(id: 2)])
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [1, 2])
        XCTAssertFalse(sut.isSearching)
    }
    
    func testFilteredCharactersIgnoresLeadingAndTrailingWhitespaces() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([
            .mock(id: 1, name: "Rick Sanchez"),
            .mock(id: 2, name: "Morty Smith")
        ])
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await search("  morty  ", in: sut)
        
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [2])
        XCTAssertTrue(sut.isSearching)
        XCTAssertState(sut.stateView, is: .showList)
    }
    
    func testFilteredCharactersSearchesByNameStatusAndSpecies() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([
            .mock(id: 1, name: "Rick Sanchez", statusRaw: "Alive", species: "Human"),
            .mock(id: 2, name: "Birdperson", statusRaw: "Dead", species: "Alien"),
            .mock(id: 3, name: "Summer Smith", statusRaw: "Alive", species: "Human")
        ])
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await search("alien", in: sut)
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [2])
        
        await search("dead", in: sut)
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [2])
        
        await search("summer", in: sut)
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [3])
    }
    
    func testSearchTextWhenNoCharactersMatchShowsNoSearchResultsState() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([
            .mock(id: 1, name: "Rick Sanchez"),
            .mock(id: 2, name: "Morty Smith")
        ])
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await search("Beth", in: sut)
        
        XCTAssertTrue(sut.filteredCharacters.isEmpty)
        XCTAssertTrue(sut.isSearching)
        XCTAssertState(sut.stateView, is: .noSearchResults)
    }
    
    func testSearchTextWhenClearedReturnsToShowListState() async {
        let repository = CharacterRepositoryMock()
        repository.localCharactersResult = .success([
            .mock(id: 1, name: "Rick Sanchez")
        ])
        let sut = makeSUT(repository: repository)
        
        await sut.loadInitialValues()
        await search("Beth", in: sut)
        searchImmediately("", in: sut)
        
        XCTAssertEqual(sut.filteredCharacters.map(\.id), [1])
        XCTAssertFalse(sut.isSearching)
        XCTAssertState(sut.stateView, is: .showList)
    }
    
    private func makeSUT(
        repository: CharacterRepositoryMock = CharacterRepositoryMock(),
        isConnected: Bool = true
    ) -> CharacterListVM {
        CharacterListVM(
            characterRepository: repository,
            networkMonitor: NetworkMonitoringMock(isConnected: isConnected)
        )
    }
    
    private func search(_ text: String, in sut: CharacterListVM) async {
        sut.searchText = text
        sut.onSearchTextChanged(text)
        try? await Task.sleep(for: .seconds(0.7))
    }
    
    private func searchImmediately(_ text: String, in sut: CharacterListVM) {
        sut.searchText = text
        sut.onSearchTextChanged(text)
    }
    
    private func XCTAssertState(
        _ state: CharacterListVM.CharacterListState,
        is expectedState: CharacterListVM.CharacterListState,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch (state, expectedState) {
        case (.idle, .idle),
             (.fetchFirstRemote, .fetchFirstRemote),
             (.showList, .showList),
             (.noSearchResults, .noSearchResults),
             (.errorStateView, .errorStateView):
            break
        default:
            XCTFail("Expected \(expectedState), got \(state)", file: file, line: line)
        }
    }
}
