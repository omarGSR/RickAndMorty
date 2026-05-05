//
//  Debouncer.swift
//  Omar Fazal
//
//  Created by silenGSR on 28/03/2026.
//

import Foundation

final class Debouncer {
    
    private let delay: Duration
    private var task: Task<Void, Never>?
    
    init(timeInSeconds: TimeInterval) {
        delay = .seconds(timeInSeconds)
    }
    
    func run(_ action: @escaping @Sendable @MainActor () -> Void) {
        
        task?.cancel()
        
        task = Task {
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            
            action()
        }
    }
    
    nonisolated func cancel() {
        Task { @MainActor [weak self] in
            self?.task?.cancel()
            self?.task = nil
        }
    }
    
    deinit {
        cancel()
    }
}
