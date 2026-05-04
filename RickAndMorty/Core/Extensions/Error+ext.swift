//
//  Error+ext.swift
//  RickAndMorty
//
//  Created by silenGSR on 04/05/2026.
//

extension Error {
    
    var titleLocalized: String {
        
        if let error = self as? APIError {
            switch error {
            case .notInternet:
                return "apiError_not_intenet_title".localized
            default:
                break
            }
        }
        
        return "gError_title".localized
    }
    
    var icon: String? {
        if let error = self as? APIError {
            switch error {
            case .notInternet:
                return "wifi.slash"
                default :
                break
            }
        }
        return nil
    }
}
