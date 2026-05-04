//
//  CharacterDTO+Mock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

extension CharacterDTO {
    
    static func mock() -> CharacterDTO {
        CharacterDTO(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: nil,
            gender: "Male",
            origin: CharacterLocationDTO(
                name: "Earth (C-137)",
                url: "https://rickandmortyapi.com/api/location/1"
            ),
            location: CharacterLocationDTO(
                name: "Citadel of Ricks",
                url: "https://rickandmortyapi.com/api/location/3"
            ),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            url: "https://rickandmortyapi.com/api/character/1",
            created: "2017-11-04T18:48:46.250Z"
        )
    }
}
