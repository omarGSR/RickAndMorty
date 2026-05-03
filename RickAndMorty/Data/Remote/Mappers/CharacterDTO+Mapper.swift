//
//  CharacterDTO+Mapper.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation

extension CharacterDTO {
    
    func toDomain() -> Character {
        Character(id: id,
                  name: name,
                  statusRaw: status,
                  species: species,
                  type: type,
                  genderRaw: gender,
                  origin: origin.toDomain(),
                  location: location.toDomain(),
                  imageURL: URL(string: image),
                  episodeIDs: episode.compactMap(\.lastPathComponentInt),
                  createdDate: DateParserFormatter.iso8601.date(from: created),
                  syncronizedDate: Date())
    }
}

private extension CharacterLocationDTO {
    
    func toDomain() -> CharacterPlace {
        CharacterPlace(name: name,
                       id: url.lastPathComponentInt)
    }
}


