//
//  CharacterRemoteDataSourceMock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

final class CharacterRemoteDataSourceMock: CharacterRemoteDataSource {
    
    private let response: Result<CharactersResponseDTO, Error>
    private(set) var receivedPages: [Int] = []
    
    init(response: Result<CharactersResponseDTO, Error>) {
        self.response = response
    }
    
    func fetchCharacter(page: Int) async throws -> CharactersResponseDTO {
        receivedPages.append(page)
        return try response.get()
    }
}
