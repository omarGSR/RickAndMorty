//
//  CharacterRemoteDataSourceMock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

final class CharacterRemoteDataSourceMock: CharacterRemoteDataSource {
    
    private let response: Result<CharactersResponseDTO, Error>
    private let characterResponse: Result<CharacterDTO, Error>
    private(set) var receivedPages: [Int] = []
    private(set) var receivedIDs: [Int] = []
    
    init(
        response: Result<CharactersResponseDTO, Error>,
        characterResponse: Result<CharacterDTO, Error> = .success(.mock())
    ) {
        self.response = response
        self.characterResponse = characterResponse
    }
    
    func fetchCharacter(page: Int) async throws -> CharactersResponseDTO {
        receivedPages.append(page)
        return try response.get()
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        receivedIDs.append(id)
        return try characterResponse.get()
    }
}
