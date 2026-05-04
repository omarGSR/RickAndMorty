//
//  Errors.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidFormat
    case emptyResponse
    case notInternet
    
    var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "apiError_invalid_format".localized
        case .emptyResponse:
            return "apiError_empty_response".localized
        case .notInternet:
            return "apiError_not_intenet_message".localized
        }
    }
}

enum EndpointError: Error, LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "apiError_invalid_url".localized
        }
    }
}

