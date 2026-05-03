//
//  Character.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation

nonisolated struct Character: Identifiable, Sendable, Hashable {
    
    let id: Int
    let name: String
    
    let statusRaw: String
    var status: CharacterStatus {
        CharacterStatus(rawValue: statusRaw.lowercased()) ?? .unknown
    }
    
    let species: String
    let type: String?
    var displaySpecies: String {
        
        let textSpecies: String = species.isEmpty ? "gUnknown".localized : species
        let typeSpecies: String = {
            guard let type else { return "" }
            return " (\(type))"
        }()
        
        return textSpecies + typeSpecies
    }
    
    let genderRaw: String
    var gender: CharacterGender {
        CharacterGender(rawValue: genderRaw.lowercased()) ?? .unknown
    }
    
    let origin: CharacterPlace
    let location: CharacterPlace
    
    let imageURL: URL?
    let episodeIDs: [Int]
    
    let createdDate: Date
    let syncronizedDate: Date
    
    init(id: Int,
         name: String,
         statusRaw: String,
         species: String,
         type: String?,
         genderRaw: String,
         origin: CharacterPlace,
         location: CharacterPlace,
         imageURL: URL?,
         episodeIDs: [Int],
         createdDate: Date,
         syncronizedDate: Date) {
        
        self.id = id
        self.name = name
        self.statusRaw = statusRaw
        self.species = species
        self.type = type
        self.genderRaw = genderRaw
        self.origin = origin
        self.location = location
        self.imageURL = imageURL
        self.episodeIDs = episodeIDs
        self.createdDate = createdDate
        self.syncronizedDate = syncronizedDate
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

nonisolated struct CharacterPlace {
    let name: String
    let id: Int?
}

nonisolated enum CharacterStatus: String {
    case alive
    case dead
    case unknown
}

nonisolated enum CharacterGender: String {
    case female
    case male
    case genderless
    case unknown
}

