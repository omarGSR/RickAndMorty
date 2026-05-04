//
//  CharacterResponseDTO.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

nonisolated struct CharactersResponseDTO: Decodable, Sendable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}

