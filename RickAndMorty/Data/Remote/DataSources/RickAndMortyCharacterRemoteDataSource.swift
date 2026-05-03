//
//  RickAndMortyCharacterRemoteDataSource.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

final class RickAndMortyCharacterRemoteDataSource: CharacterRemoteDataSource {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchCharacter(page: Int) async throws -> CharactersResponseDTO {
        try await apiClient.request(.characters(page: page))
    }
}

