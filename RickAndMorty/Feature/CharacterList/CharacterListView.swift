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
        .errorAlert(error: $viewModel.errorAlert)
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
                    
                    NavigationLink {
                        #warning("TODO: replace with proper VM container")
                        let vm = DetailCharacterVM(character: character)
                        
                        DetailCharacterView(viewModel: vm)
                        
                    } label: {
                        CharacterRowView(character: character)
                    }
                }
                
                footerListPagination
            }
            
        case .idle, .fetchFirstRemote:
            
            LoadingSpinner()
            
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
    
    @ViewBuilder
    private var footerListPagination: some View {
        
        if viewModel.isPaginationAvailable {
            
            if !viewModel.isConectionReachable ||
                viewModel.forceShowButtonLoadMore {
                
                HStack {
                    Spacer()
                    Button("clv_load_more_pages") {
                        Task {
                            await viewModel.fetchNextRemotePage()
                        }
                    }
                    Spacer()
                }
            }
            else {
                HStack {
                    LoadingSpinner()
                        .id(viewModel.currentPage)
                }
                .onScrollVisibilityChange { isVisible in
                    Task {
                        await viewModel.fetchNextRemotePage()
                    }
                }
            }
        }
    }
}
