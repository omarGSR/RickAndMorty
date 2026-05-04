//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct CharacterRowView: View {
    
    let character: Character
    
    var body: some View {
        HStack(spacing: Spacing.regular) {
            RemoteImageView(url: character.imageURL)
                .frame(width: 65, height: 65)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: Spacing.quarter) {
                Text(character.name)
                    .titleItemStyle()
                
                Text(character.displaySpecies)
                    .descriptionItemStyle(color: .primary)
                
                Text("chm_display_status".localized([character.status.display]))
                    .descriptionItemStyle()
                
                Text("chm_display_create_at".localized([character.displayCreated]))
                    .descriptionItemStyle()
            }
        }
        .padding(.vertical, Spacing.half)
    }
}

#Preview {
    
    let character = Character(id: 1,
                              name: "Rick Sanches",
                              statusRaw: "Alive",
                              species: "Human",
                              type: nil,
                              genderRaw: "Male",
                              origin: CharacterPlace(name: "unknown",
                                                     id: nil),
                              location: CharacterPlace(name: "unknown",
                                                       id: nil),
                              imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"), episodeIDs: [1,2,3],
                              createdDate: Date(),
                              syncronizedDate: Date())
    
    CharacterRowView(character: character)
    Spacer()
}
