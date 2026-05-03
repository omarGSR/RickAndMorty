//
//  CharacterEntity+Mapper.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation

extension CharacterEntity {
    
    convenience init(character: Character) {
        self.init(id: character.id,
                  name: character.name,
                  statusRaw: character.statusRaw,
                  species: character.species,
                  type: character.type,
                  genderRaw: character.genderRaw,
                  originName: character.origin.name,
                  originID: character.origin.id,
                  locationName: character.location.name,
                  locationID: character.location.id,
                  imageURLString: character.imageURL?.absoluteString,
                  episodeIDs: character.episodeIDs,
                  createdDate: character.createdDate,
                  syncronizedDate: character.syncronizedDate)
    }
    
    func update(with character: Character) {
        name = character.name
        statusRaw = character.statusRaw
        species = character.species
        type = character.type
        genderRaw = character.genderRaw
        originName = character.origin.name
        originID = character.origin.id
        locationName = character.location.name
        locationID = character.location.id
        imageURLString = character.imageURL?.absoluteString
        episodeIDs = character.episodeIDs
        createdDate = character.createdDate
        syncronizedDate = character.syncronizedDate
    }
    
    func toDomain() -> Character {
        Character(id: id,
                  name: name,
                  statusRaw: statusRaw,
                  species: species,
                  type: type,
                  genderRaw: genderRaw,
                  origin: CharacterPlace(name: originName,
                                         id: originID),
                  location: CharacterPlace(name: locationName,
                                           id: locationID),
                  imageURL: imageURLString.flatMap(URL.init(string:)),
                  episodeIDs: episodeIDs,
                  createdDate: createdDate,
                  syncronizedDate: syncronizedDate)
    }
}


