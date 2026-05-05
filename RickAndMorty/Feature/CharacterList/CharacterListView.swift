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
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "_search by name, status, species"
                )
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.onSearchTextChanged(newValue)
                }
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
            
        case .noSearchResults:
            
            StateViewFeedback(
                icon: "person.slah",
                title: "clv_empty_result_title",
                message: "clv_empty_result_description",
                buttonTitle: nil,
                action: nil)
            .padding(Spacing.regular)
            .padding(.top, Spacing.double)
            Spacer()
            
        case .showList:
            
                List {
                    ForEach(viewModel.filteredCharacters) { character in
                        
                        NavigationLink {
                            
                            DetailCharacterView(
                                viewModel: AppContainer.shared.makeDetailCharacterVM(character: character)
                            )
                            
                        } label: {
                            CharacterRowView(character: character)
                        }
                    }
                    
                    if !viewModel.isSearching {
                        footerListPagination
                    }
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
