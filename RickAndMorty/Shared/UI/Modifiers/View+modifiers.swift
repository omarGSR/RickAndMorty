//
//  View+modifiers.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct HeadlineStyle: ViewModifier {
    var color: Color = .primary
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(color)
    }
}

struct SubheadlineStyle: ViewModifier {
    var color: Color = .secondary
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundStyle(color)
    }
}

extension View {
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - For Text helper
    
    func titleItemStyle(color: Color = .primary) -> some View {
        modifier(HeadlineStyle(color: color))
    }
    
    func descriptionItemStyle(color: Color = .secondary) -> some View {
        modifier(SubheadlineStyle(color: color))
    }
}
