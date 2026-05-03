//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

protocol CharacterRepository {
    func fetchCharacter(page: Int) async throws -> PageResults<Character>
    func localCharacters() async throws -> [Character]
}
