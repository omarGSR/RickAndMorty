//
//  SwiftDataSourceTests.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

import SwiftData
import XCTest
@testable import RickAndMorty

@MainActor
final class SwiftDataSourceTests: XCTestCase {
    
    func testSaveCharactersPersistsAndReturnsSortedCharacters() async throws {
        let sut = try makeSUT()
        let morty = Character.mock(id: 2, name: "Morty Smith")
        let rick = Character.mock(id: 1, name: "Rick Sanchez")
        
        try await sut.saveCharacters([morty, rick])
        
        let characters = try await sut.getCharacters()
        
        XCTAssertEqual(characters.map(\.id), [1, 2])
        XCTAssertEqual(characters.map(\.name), ["Rick Sanchez", "Morty Smith"])
    }
    
    func testSaveCharactersPageInfoPersistsAndUpdatesPageInfo() async throws {
        let sut = try makeSUT()
        
        try await sut.saveCharactersPageInfo(.mock(currentPage: 1, nextPage: 2))
        try await sut.saveCharactersPageInfo(.mock(currentPage: 2, nextPage: 3))
        
        let pageInfo = try await sut.getCharactersPageInfo()
        
        XCTAssertEqual(pageInfo?.currentPage, 2)
        XCTAssertEqual(pageInfo?.nextPage, 3)
        XCTAssertEqual(pageInfo?.previousPage, 1)
    }
    
    private func makeSUT() throws -> SwiftDataSource {
        let context = try makeInMemoryModelContext()
        try context.delete(model: CharacterEntity.self)
        try context.delete(model: PageInfoEntity.self)
        try context.save()
        
        return SwiftDataSource(context: context)
    }
    
    private func makeInMemoryModelContext() throws -> ModelContext {
        let schema = Schema([
            PageInfoEntity.self,
            CharacterEntity.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        return ModelContext(container)
    }
}
