//
//  CharacterRemoteDataSource.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

protocol CharacterRemoteDataSource {
    func fetchCharacter(page: Int) async throws -> CharactersResponseDTO
    func fetchCharacter(id: Int) async throws -> CharacterDTO
}
