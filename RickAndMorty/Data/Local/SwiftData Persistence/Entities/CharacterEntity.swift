//
//  CharacterEntity.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation
import SwiftData

@Model
final class CharacterEntity {
    
    @Attribute(.unique) var id: Int
    var name: String
    var statusRaw: String
    var species: String
    var type: String?
    var genderRaw: String
    var originName: String
    var originID: Int?
    var locationName: String
    var locationID: Int?
    var imageURLString: String?
    var episodeIDs: [Int]
    var createdDate: Date?
    var syncronizedDate: Date
    
    init(id: Int,
         name: String,
         statusRaw: String,
         species: String,
         type: String?,
         genderRaw: String,
         originName: String,
         originID: Int?,
         locationName: String,
         locationID: Int?,
         imageURLString: String?,
         episodeIDs: [Int],
         createdDate: Date?,
         syncronizedDate: Date) {
        
        self.id = id
        self.name = name
        self.statusRaw = statusRaw
        self.species = species
        self.type = type
        self.genderRaw = genderRaw
        self.originName = originName
        self.originID = originID
        self.locationName = locationName
        self.locationID = locationID
        self.imageURLString = imageURLString
        self.episodeIDs = episodeIDs
        self.createdDate = createdDate
        self.syncronizedDate = syncronizedDate
    }
}

