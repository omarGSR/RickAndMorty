//
//  PageInfo+Mock.swift
//  RickAndMortyTests
//
//  Created by Codex on 04/05/2026.
//

@testable import RickAndMorty

extension PageInfo {
    
    static func mock(
        totalItems: Int = 826,
        totalPages: Int = 42,
        currentPage: Int = 1,
        nextPage: Int? = 2,
        previousPage: Int? = 1
    ) -> PageInfo {
        PageInfo(
            totalItems: totalItems,
            totalPages: totalPages,
            currentPage: currentPage,
            nextPage: nextPage,
            previousPage: previousPage
        )
    }
}
