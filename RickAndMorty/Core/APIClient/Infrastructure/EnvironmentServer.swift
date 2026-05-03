//
//  EnvironmentServer.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/26.
//

enum EnvironmentServer: String, CaseIterable {
    case prod
    case staging
    case dev
    
    var baseURL: String {
        switch self {
        case .prod: return "https://prod-rickandmortyapi.com"
        case .staging: return "https://staging-rickandmortyapi.com"
        case .dev:  return "https://rickandmortyapi.com"
        }
    }
}
