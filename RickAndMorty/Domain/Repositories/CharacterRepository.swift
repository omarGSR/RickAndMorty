//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

protocol CharacterRepository {
    func fetchCharacter(page: Int) async throws -> PageResults<Character>
    func syncCharacter(id: Int) async throws -> Character
    func localCharacters() async throws -> [Character]
    func localCharactersPageInfo() async throws -> PageInfo?
}
