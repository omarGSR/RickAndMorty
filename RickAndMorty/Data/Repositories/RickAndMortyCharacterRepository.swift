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
        
        try await localDataSource.saveCharacters(pageResult.items)
        
        if let pageInfo = pageResult.pageInfo {
            try await localDataSource.saveCharactersPageInfo(pageInfo)
        }
        
        return pageResult
    }
    
    func syncCharacter(id: Int) async throws -> Character {
        
        let characterDTO = try await remoteDataSource.fetchCharacter(id: id)
        let character = characterDTO.toDomain()
        try await localDataSource.saveCharacters([character])
        return character
    }
    
    func localCharacters() async throws -> [Character] {
        try await localDataSource.getCharacters()
    }
    
    func localCharactersPageInfo() async throws -> PageInfo? {
        try await localDataSource.getCharactersPageInfo()
    }
}
