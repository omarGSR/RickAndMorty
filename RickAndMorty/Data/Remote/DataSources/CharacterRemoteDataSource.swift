//
//  CharacterRemoteDataSource.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

protocol CharacterRemoteDataSource {
    func fetchCharacter(page: Int) async throws -> CharactersResponseDTO
}
