//
//  DetailCharacterVMTests.swift
//  RickAndMortyTests
//
//  Created by Codex on 05/05/2026.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class DetailCharacterVMTests: XCTestCase {
    
    func testSyncronizeWhenRepositorySucceedsUpdatesDisplayedCharacter() async {
        let repository = CharacterRepositoryMock()
        repository.syncCharacterResult = .success(
            .mock(id: 1, name: "Morty Smith", statusRaw: "Dead", species: "Human")
        )
        let sut = DetailCharacterVM(
            character: .mock(id: 1, name: "Rick Sanchez", statusRaw: "Alive", species: "Human"),
            characterRepository: repository,
            networkMonitor: NetworkMonitoringMock(isConnected: true)
        )
        
        await sut.syncronize()
        
        XCTAssertEqual(repository.receivedSyncIDs, [1])
        XCTAssertEqual(sut.displayName, "Morty Smith")
        XCTAssertEqual(sut.displaySpecies, "Human")
        XCTAssertFalse(sut.isSyncing)
        XCTAssertNil(sut.errorAlert)
    }
    
    func testSyncronizeWhenRepositoryFailsKeepsCharacterAndShowsError() async {
        let repository = CharacterRepositoryMock()
        repository.syncCharacterResult = .failure(RepositoryTestError.remoteFailure)
        let sut = DetailCharacterVM(
            character: .mock(id: 1, name: "Rick Sanchez", statusRaw: "Alive", species: "Human"),
            characterRepository: repository,
            networkMonitor: NetworkMonitoringMock(isConnected: true)
        )
        
        await sut.syncronize()
        
        XCTAssertEqual(repository.receivedSyncIDs, [1])
        XCTAssertEqual(sut.displayName, "Rick Sanchez")
        XCTAssertEqual(sut.errorAlert as? RepositoryTestError, .remoteFailure)
        XCTAssertFalse(sut.isSyncing)
    }
}
