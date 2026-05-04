//
//  PersistenceDataSource.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

protocol PersistenceDataSource {
    func getCharacters() async throws -> [Character]
    func saveCharacters(_ characters: [Character]) async throws
    
    func getCharactersPageInfo() async throws -> PageInfo?
    func saveCharactersPageInfo(_ pageInfo: PageInfo) async throws
}
