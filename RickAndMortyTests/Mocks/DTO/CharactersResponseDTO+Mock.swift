//
//  CharactersResponseDTO+Mock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

extension CharactersResponseDTO {
    
    static func mock() -> CharactersResponseDTO {
        CharactersResponseDTO(
            info: PageInfoDTO(
                count: 826,
                pages: 42,
                next: "https://rickandmortyapi.com/api/character?page=3",
                prev: "https://rickandmortyapi.com/api/character?page=1"
            ),
            results: [.mock()]
        )
    }
}
