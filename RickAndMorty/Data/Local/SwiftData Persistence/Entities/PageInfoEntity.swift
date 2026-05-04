//
//  PageInfoEntity.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation
import SwiftData

@Model
final class PageInfoEntity {
    
    @Attribute(.unique) var id: String
    var totalItems: Int
    var totalPages: Int
    var currentPage: Int
    var nextPage: Int?
    var previousPage: Int?
    var updatedAt: Date
    
    init(id: String,
         totalItems: Int,
         totalPages: Int,
         currentPage: Int,
         nextPage: Int?,
         previousPage: Int?,
         updatedAt: Date = Date()) {
        
        self.id = id
        self.totalItems = totalItems
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        self.updatedAt = updatedAt
    }
}


