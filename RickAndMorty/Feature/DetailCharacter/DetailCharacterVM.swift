//
//  DetailCharacterVM.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class DetailCharacterVM {
    
    private var character: Character
    
    var displayImageURL: URL? { character.imageURL }
    var displayName: String { character.name }
    var displayStatus: String {
        "chm_display_status".localized([character.status.display])
    }
    var displaySpecies: String { character.displaySpecies }
    
    var displayGender: String {
        "chm_display_gender".localized([character.gender.display])
    }
    var displaySyncronizedAt: String {
        "chm_display_syncronized_at".localized([character.displaySyncronized])
    }
    
    var displayOriginLocation: String { character.origin.name }
    var displayCurrentLocation: String { character.location.name}
    
    var displayCreatedAt: String {
        "chm_display_created_at".localized([character.displayCreated])
    }
    
    var displayParticipatedEpisodes: String { "chm_display_participated_episodes".localized([character.episodeIDs.count])
    }
    
    
    
    var needSyncFromServer: Bool {
#warning("TODO: for other version update character just to know if something has changes (episodes, status{dead},..)")
        let daysToUpdate: Int = 30
        let timeInterval = TimeInterval(daysToUpdate * 3600 * 3600 * 24)
        // remove hardcode value when implementation are ready
        return false
        return character.syncronizedDate.addingTimeInterval(timeInterval) < Date()
    }
    
    init(character: Character) {
        self.character = character
    }
}
