//
//  ProgressViewWapper.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        Spacer()
        TimelineView(.animation) { timeline in
            let angle = timeline.date.timeIntervalSinceReferenceDate * 360
            
            Circle()
                .trim(from: 0.05, to: 0.78)
                .stroke(
                    AngularGradient(
                        colors: [
                            .primary.opacity(0.1),
                            .primary.opacity(1)
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 2.4, lineCap: .round)
                )
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(angle))
        }
        Spacer()
    }
}

#Preview {
    LoadingSpinner()
    Spacer()
}
