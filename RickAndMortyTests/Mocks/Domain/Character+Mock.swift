//
//  Character+Mock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

import Foundation
@testable import RickAndMorty

extension Character {
    
    static func mock(
        id: Int = 1,
        name: String = "Rick Sanchez"
    ) -> Character {
        Character(
            id: id,
            name: name,
            statusRaw: "Alive",
            species: "Human",
            type: nil,
            genderRaw: "Male",
            origin: CharacterPlace(name: "Earth (C-137)", id: 1),
            location: CharacterPlace(name: "Citadel of Ricks", id: 3),
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg"),
            episodeIDs: [1, 2],
            createdDate: Date(timeIntervalSince1970: 0),
            syncronizedDate: Date(timeIntervalSince1970: 50)
        )
    }
}
