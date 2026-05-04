//
//  PageResults.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

nonisolated struct PageResults<Item: Sendable>: Sendable {
    let pageInfo: PageInfo?
    let items: [Item]
}

nonisolated struct PageInfo: Sendable {
    let totalItems: Int
    let totalPages: Int
    let currentPage: Int
    let nextPage: Int?
    let previousPage: Int?
}
