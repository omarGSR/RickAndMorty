//
//  RequestTimeout.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/26.
//

import Foundation

enum RequestTimeout {
    case short
    case `default`
    case long
    case custom(TimeInterval)
    
    var value: TimeInterval {
        switch self {
        case .short:
            return 15
        case .default:
            return 30
        case .long:
            return 60
        case .custom(let seconds):
            return seconds
        }
    }
}
