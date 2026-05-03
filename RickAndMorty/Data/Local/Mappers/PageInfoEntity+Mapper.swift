//
//  PageInfoEntity+Mapper.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation

extension PageInfoEntity {
    
    convenience init(id: String,
                     pageInfo: PageInfo) {
        
        self.init(id: id,
                  totalItems: pageInfo.totalItems,
                  totalPages: pageInfo.totalPages,
                  currentPage: pageInfo.currentPage,
                  nextPage: pageInfo.nextPage,
                  previousPage: pageInfo.previousPage)
    }
    
    func update(with pageInfo: PageInfo) {
        
        totalItems = pageInfo.totalItems
        totalPages = pageInfo.totalPages
        currentPage = pageInfo.currentPage
        nextPage = pageInfo.nextPage
        previousPage = pageInfo.previousPage
        updatedAt = Date()
    }
    
    func toDomain() -> PageInfo {
        
        PageInfo(totalItems: totalItems,
                 totalPages: totalPages,
                 currentPage: currentPage,
                 nextPage: nextPage,
                 previousPage: previousPage)
    }
}
