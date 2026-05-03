//
//  View+ext.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/2026.
//


import SwiftUI

extension View {
    
    // MARK: - Alerts
    
    func errorAlert(error: Binding<Error?>,
                    title: String = "gErrorTitle") -> some View {
        
        self.alert(
            title.localized,
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { newValue in
                    if newValue == false {
                        error.wrappedValue = nil
                    }
                }
            ),
            actions: {
                Button("gOK", role: .cancel) { }
            },
            message: {
                Text(error.wrappedValue?.localizedDescription ?? "gErrorUnknow".localized)
            }
        )
    }
}
