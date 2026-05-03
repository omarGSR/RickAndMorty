//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import SwiftUI
import SwiftData

@main
struct RickAndMortyApp: App {

    private let container = AppContainer.shared
    
    var body: some Scene {
        WindowGroup {
            TestContentView()
        }
    }
}
