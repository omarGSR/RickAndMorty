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
    
    var displayName: String { character.name }
    var displayStatus: String { character.status.display }
    var displayGender: String { character.gender.display }
    var displayImageURL: URL? { character.imageURL }
    var displaySpecies: String { character.displaySpecies }
    
    var needSyncFromServer: Bool {
        #warning("TODO: for other version update character just to know if something has changes (episodes, status{dead},..)")
        let daysToUpdate: Int = 30
        let timeInterval = TimeInterval(daysToUpdate * 3600 * 3600 * 24)
        
       return character.syncronizedDate.addingTimeInterval(timeInterval) < Date()
      }
    
    init(character: Character) {
        self.character = character
    }
}
