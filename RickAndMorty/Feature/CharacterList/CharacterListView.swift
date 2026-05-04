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
                .navigationTitle("clv_title")
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
                    CharacterRowView(character: character)
                }
            }
            
        case .idle, .fetchFirstRemote:
            
            ProgressViewWrapper()
            
        case .errorStateView:
            
            StateViewFeedback(
                error: viewModel.errorFirstEvaluate,
                buttonTitle: "gRetry".localized
            ) {
                Task {
                    await viewModel.loadInitialValues(isRetry: true)
                }
            }
            .padding(Spacing.regular)
        }
    }
}
