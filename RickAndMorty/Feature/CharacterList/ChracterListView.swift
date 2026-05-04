//
//  ChracterListView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct CharacterListView: View {
    
    @State var viewModel: CharacterListVM
    
    init(viewModel: CharacterListVM) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("_Rick And Morty")
        }
        .onAppear {
            Task {
                await viewModel.loadInitialValues()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.stateView {
        case .showList:
            
            List {
                ForEach(viewModel.characters) { character in
                    Text(character.name)
                }
            }
            
            
        case .idle:
            Text("inital empty")
        case .fetchFirstRemote:
            Text("need to fetch")
        case .notInternet:
            Text("not internet")
        }
        
        
    }
}
