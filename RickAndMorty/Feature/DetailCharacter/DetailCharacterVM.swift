//
//  DetailCharacterVM.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import Observation

@MainActor
@Observable
final class DetailCharacterVM {
    
    var character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    
    
}
