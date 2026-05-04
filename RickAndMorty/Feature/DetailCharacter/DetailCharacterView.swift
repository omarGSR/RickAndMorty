//
//  DetailCharacterView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct DetailCharacterView: View {
    
    @State var viewModel: DetailCharacterVM
    
    init(viewModel: DetailCharacterVM) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            RemoteImageView(url: viewModel.character.imageURL)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            Text(viewModel.character.name)
            Spacer()
            
            
        }
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
    
    let vm = DetailCharacterVM(character: character)
    DetailCharacterView(viewModel: vm)
    Spacer()
}
