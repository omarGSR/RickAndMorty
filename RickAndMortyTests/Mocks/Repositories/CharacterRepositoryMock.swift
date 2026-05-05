//
//  CharacterRepositoryMock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

final class CharacterRepositoryMock: CharacterRepository {
    
    var localCharactersResult: Result<[Character], Error> = .success([])
    var localCharactersPageInfoResult: Result<PageInfo?, Error> = .success(nil)
    var fetchCharacterResult: Result<PageResults<Character>, Error> = .success(
        PageResults(pageInfo: nil, items: [])
    )
    var syncCharacterResult: Result<Character, Error> = .success(.mock())
    
    private(set) var localCharactersCallCount = 0
    private(set) var localCharactersPageInfoCallCount = 0
    private(set) var receivedPages: [Int] = []
    private(set) var receivedSyncIDs: [Int] = []
    
    func localCharacters() async throws -> [Character] {
        localCharactersCallCount += 1
        return try localCharactersResult.get()
    }
    
    func localCharactersPageInfo() async throws -> PageInfo? {
        localCharactersPageInfoCallCount += 1
        return try localCharactersPageInfoResult.get()
    }
    
    func fetchCharacter(page: Int) async throws -> PageResults<Character> {
        receivedPages.append(page)
        return try fetchCharacterResult.get()
    }
    
    func syncCharacter(id: Int) async throws -> Character {
        receivedSyncIDs.append(id)
        return try syncCharacterResult.get()
    }
}
