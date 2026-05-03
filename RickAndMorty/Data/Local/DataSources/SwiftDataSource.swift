//
//  SwiftDataSource.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation
import SwiftData

final class SwiftDataSource: PersistenceDataSource {
    
    private enum Constants {
        static let charactersPageInfoID = "characters"
        static let locationPageInfoID = "location"
    }
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Characters
    
    func getCharacters() async throws -> [Character] {
        
        let descriptor = FetchDescriptor<CharacterEntity>(
            sortBy: [SortDescriptor(\.id)]
        )
        
        return try context.fetch(descriptor).map { $0.toDomain() }
    }
    
    func saveCharacters(_ characters: [Character]) async throws {
        
        for character in characters {
            
            if let entity = try await getCharacterEntity(id: character.id) {
                entity.update(with: character)
            }
            else {
                context.insert(CharacterEntity(character: character))
            }
        }
        
        try context.save()
    }
    
    private func getCharacterEntity(id: Int) async throws -> CharacterEntity? {
        
        var descriptor = FetchDescriptor<CharacterEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        descriptor.fetchLimit = 1
        
        return try context.fetch(descriptor).first
    }
    
    // MARK: - Characters Page Info
    
    func getCharactersPageInfo() async throws -> PageInfo? {
        try getPageInfoEntity(id: Constants.charactersPageInfoID)?.toDomain()
    }
    
    func saveCharactersPageInfo(_ pageInfo: PageInfo) async throws {
        
        if let entity = try getPageInfoEntity(id: Constants.charactersPageInfoID) {
            entity.update(with: pageInfo)
        }
        else {
            context.insert(
                PageInfoEntity(id: Constants.charactersPageInfoID,
                               pageInfo: pageInfo)
            )
        }
        
        try context.save()
    }
    
    private func getPageInfoEntity(id: String) throws -> PageInfoEntity? {
        
        var descriptor = FetchDescriptor<PageInfoEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        descriptor.fetchLimit = 1
        
        return try context.fetch(descriptor).first
    }
}


