//
//  PersistenceDataSourceMock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

final class PersistenceDataSourceMock: PersistenceDataSource {
    
    private(set) var savedCharacters: [Character] = []
    private(set) var savedPageInfo: PageInfo?
    
    func getCharacters() async throws -> [Character] {
        []
    }
    
    func saveCharacters(_ characters: [Character]) async throws {
        savedCharacters.append(contentsOf: characters)
    }
    
    func getCharactersPageInfo() async throws -> PageInfo? {
        nil
    }
    
    func saveCharactersPageInfo(_ pageInfo: PageInfo) async throws {
        savedPageInfo = pageInfo
    }
}
