//
//  DetailCharacterView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct DetailCharacterView: View {
    
    @State var viewModel: DetailCharacterVM
    
    let verticalSectionSpacing: CGFloat = Spacing.quarter
    
    init(viewModel: DetailCharacterVM) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            
            header
            sectionInfo
            sectionLocation
                .padding(.top, -Spacing.regular)
            sectionSync
                .padding(.top, -Spacing.regular)
            
            Spacer()
        }
    }
    
    private var header: some View {
        VStack(spacing: verticalSectionSpacing) {
            
            RemoteImageView(url: viewModel.displayImageURL)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            
            Text(viewModel.displayName)
                .titleItemStyle()
                .padding(.top, Spacing.regular)
            
            Text(viewModel.displaySpecies)
                .descriptionItemStyle(color: .primary)
            
            Text("chm_display_status".localized([viewModel.displayStatus]))
                .descriptionItemStyle()
        }
        .padding(Spacing.regular)
    }
    
    private var sectionInfo: some View {
        
        GroupBox {
            VStack(alignment: .leading, spacing: verticalSectionSpacing) {
                
                Text("_gender: Male")
                Text("_participate in 88 episodes")
                Text("_create at: Juny 20226")
            }
            .padding(.leading, Spacing.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } label : {
            Text("_info")
        }
        .padding(Spacing.regular)
    }
    
    private var sectionLocation: some View {
        
        GroupBox {
            VStack(alignment: .leading, spacing: verticalSectionSpacing) {
                
                Text("_original from:")
                Text("unknow")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("_current:")
                Text("unknow")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.leading, Spacing.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } label : {
            Text("_location")
            
        }
        .padding(Spacing.regular)
    }
    
    private var sectionSync: some View {
        GroupBox {
            VStack(alignment: .center, spacing: verticalSectionSpacing) {
                
                Spacer()
                Button("sync") {
                    
                }
                .disabled(!viewModel.needSyncFromServer)
                .buttonStyle(.borderedProminent)
            }
            .padding(.leading, Spacing.regular)
            
        } label : {
            Text("_last syncronized 23/5/20026")
            
        }
        .padding(Spacing.regular)
        
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
