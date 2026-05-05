//
//  RickAndMortyCharacterRepositoryTests.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class RickAndMortyCharacterRepositoryTests: XCTestCase {
    
    func testFetchCharacterWhenRemoteSucceedsSavesCharactersAndPageInfo() async throws {
        let remoteDataSource = CharacterRemoteDataSourceMock(
            response: .success(.mock())
        )
        let localDataSource = PersistenceDataSourceMock()
        let sut = RickAndMortyCharacterRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        
        let result = try await sut.fetchCharacter(page: 2)
        
        XCTAssertEqual(remoteDataSource.receivedPages, [2])
        XCTAssertEqual(result.items.map(\.id), [1])
        XCTAssertEqual(result.pageInfo?.currentPage, 2)
        XCTAssertEqual(result.pageInfo?.nextPage, 3)
        XCTAssertEqual(result.pageInfo?.previousPage, 1)
        XCTAssertEqual(localDataSource.savedCharacters.map(\.id), [1])
        XCTAssertEqual(localDataSource.savedPageInfo?.currentPage, 2)
        XCTAssertEqual(localDataSource.savedPageInfo?.nextPage, 3)
    }
    
    func testFetchCharacterWhenRemoteFailsDoesNotPersistAndThrowsError() async {
        let remoteDataSource = CharacterRemoteDataSourceMock(
            response: .failure(RepositoryTestError.remoteFailure)
        )
        let localDataSource = PersistenceDataSourceMock()
        let sut = RickAndMortyCharacterRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        
        do {
            _ = try await sut.fetchCharacter(page: 1)
            XCTFail("Expected fetchCharacter to throw")
        } catch {
            XCTAssertEqual(error as? RepositoryTestError, .remoteFailure)
            XCTAssertEqual(remoteDataSource.receivedPages, [1])
            XCTAssertTrue(localDataSource.savedCharacters.isEmpty)
            XCTAssertNil(localDataSource.savedPageInfo)
        }
    }
    
    func testSyncCharacterWhenRemoteSucceedsSavesAndReturnsCharacter() async throws {
        let remoteDataSource = CharacterRemoteDataSourceMock(
            response: .success(.mock()),
            characterResponse: .success(.mock())
        )
        let localDataSource = PersistenceDataSourceMock()
        let sut = RickAndMortyCharacterRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        
        let currentHourString: String = Date().formatted(date: .omitted, time: .shortened)
        let suffix = " -> manual sync \(currentHourString)"
        
        let result = try await sut.syncCharacter(id: 1)
        
        XCTAssertEqual(remoteDataSource.receivedIDs, [1])
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Rick Sanchez\(suffix)")
        XCTAssertEqual(localDataSource.savedCharacters.map(\.id), [1])
        XCTAssertNil(localDataSource.savedPageInfo)
    }
}
