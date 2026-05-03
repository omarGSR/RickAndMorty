//
//  ContentView.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import SwiftUI
import SwiftData

struct TestContentView: View {

    var body: some View {
        Text("Test content view")
        Button("Get from remoteDataSource\nwith Repository") {
            Task {
                
                let repository = AppContainer.shared.makeCharacterRepository()
               
                do {
                    var savedItems = try await repository.localCharacters()
                    print(savedItems)
                    print("-> total saved: \(savedItems.count)")
                    
                    var pageResults = try await repository.fetchCharacter(page: 1)
                    
                    print(pageResults.items)
                    print("-> total items fetched: \(pageResults.items.count)")
                    
                    savedItems = try await repository.localCharacters()
                    print("saved items after page 1: \(savedItems.count)")
                    
                    print("-> --- page 2")
                    pageResults = try await repository.fetchCharacter(page: 2)
                    print(pageResults.items)
                    print("-> total items fetched: \(pageResults.items.count)")
                    savedItems = try await repository.localCharacters()
                    print("-> total saved: \(savedItems.count)")
                    
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    TestContentView()
}
