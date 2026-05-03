//
//  PageInfoDTO.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

nonisolated struct PageInfoDTO: Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
