//
//  RickAndMortyCharacterRepository.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

final class RickAndMortyCharacterRepository: CharacterRepository {
    
    private let remoteDataSource: CharacterRemoteDataSource
    private let localDataSource: PersistenceDataSource
    
    init(remoteDataSource: CharacterRemoteDataSource,
         localDataSource: PersistenceDataSource) {
        
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchCharacter(page: Int) async throws -> PageResults<Character> {
        let response = try await remoteDataSource.fetchCharacter(page: page)
        let pageResult = response.toDomain(currentPage: page)
        
        #warning("TODO: need to save in local")
        
        return pageResult
    }
    
    func localCharacters() async throws -> [Character] {
        try await localDataSource.getCharacters()
    }
}

