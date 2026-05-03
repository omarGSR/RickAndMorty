//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

nonisolated struct CharacterDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let origin: CharacterLocationDTO
    let location: CharacterLocationDTO
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

nonisolated struct CharacterLocationDTO: Decodable, Sendable {
    let name: String
    let url: String
}
