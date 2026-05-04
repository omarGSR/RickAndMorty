//
//  RemoteImageView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI
import NukeUI

struct RemoteImageView: View {
    
    let url: URL?
    let placeHolderBackground: Color
    let placeHolderForeground: Color
    
    let errorBackground: Color
    let errorForeground: Color

    init(url: URL?,
         placeHolderBackground: Color = .clear,
         placeHolderForeground: Color = .secondary,
         errorBackground: Color = .gray.opacity(0.3),
         errorForeground: Color = .secondary) {
        
        self.url = url
        self.placeHolderBackground = placeHolderBackground
        self.placeHolderForeground = placeHolderForeground
        self.errorBackground = errorBackground
        self.errorForeground = errorForeground
    }

    var body: some View {
        
        LazyImage(url: url) { state in
            
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
            }
            else if state.error != nil {
                errorView
            }
            else {
                placeHolderView
            }
        }
    }
    
    private var errorView: some View {
        ZStack {
            errorBackground
            
            Image(systemName: "photo.trianglebadge.exclamationmark")
                .font(.title)
                .foregroundStyle(errorForeground)
        }
    }
    
    private var placeHolderView: some View {
        ZStack {
            placeHolderBackground
            
            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(placeHolderForeground)
        }
    }
}


