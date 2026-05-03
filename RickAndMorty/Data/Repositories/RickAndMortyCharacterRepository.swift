//
//  RickAndMortyCharacterRepository.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

final class RickAndMortyCharacterRepository: CharacterRepository {
    
    private let remoteDataSource: CharacterRemoteDataSource
    
    init(remoteDataSource: CharacterRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchCharacter(page: Int) async throws -> PageResults<Character> {
        let response = try await remoteDataSource.fetchCharacter(page: page)
        let pageResult = response.toDomain(currentPage: page)

        return pageResult
    }
    
    func localCharacters() async throws -> [Character] {
#warning("TODO: need implement Persistence data base")
        return []
    }
}

