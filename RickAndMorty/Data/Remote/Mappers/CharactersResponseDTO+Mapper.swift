//
//  Untitled.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

extension CharactersResponseDTO {
    
    func toDomain(currentPage: Int) -> PageResults<Character> {
        PageResults(
            pageInfo: PageInfo(
                totalItems: info.count,
                totalPages: info.pages,
                currentPage: currentPage,
                nextPage: info.next?.queryPage,
                previousPage: info.prev?.queryPage
            ),
            items: results.map { $0.toDomain() }
        )
    }
}

