//
//  FeedbackStateView.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct StateViewFeedback: View {
    let icon: String?
    let title: String
    let message: String?
    let buttonTitle: String?
    let action: (() -> Void)?
    
    init(icon: String?,
         title: String,
         message: String?,
         buttonTitle: String?,
         action: (() -> Void)?) {
        
        self.icon = icon
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    init(error: Error?,
         buttonTitle: String?,
         action: (() -> Void)?) {
        
        self.init(icon: error?.icon,
                  title: error?.titleLocalized ?? "gError_title",
                  message: error?.localizedDescription ?? "gError_description".localized,
                  buttonTitle: buttonTitle?.localized,
                  action: action)
    }
    
    
    var body: some View {
        VStack(spacing: Spacing.regular) {
            
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(.title3)
                .bold()
            
            if let message {
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let buttonTitle, let action {
                Button(buttonTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, Spacing.half)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.secondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
}


#Preview {
    StateViewFeedback(
        icon: "wifi.slash",
        title: "No Internet",
        message: "Check your connection and try again",
        buttonTitle: "Retry",
        action: {}
    )
    
    StateViewFeedback(error: APIError.notInternet, buttonTitle: "gRetry", action: {})
    
}
