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
                    let pageResults = try await repository.fetchCharacter(page: 1)
                    
                    print(pageResults.items)
                    print("total items: \(pageResults.items.count)")
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
