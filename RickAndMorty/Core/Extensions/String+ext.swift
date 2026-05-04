//
//  String+ext.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/2026.
//

import Foundation

nonisolated extension String {
        
    // MARK: Localized
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ params: [CVarArg]) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString(self, comment: ""),
            params
        )
    }
    
    // MARK: - URL components + query
    
    var lastPathComponentInt: Int? {
        guard let url = URL(string: self) else { return nil }
        return Int(url.lastPathComponent)
        
    
    }
    
    func queryValue<T: LosslessStringConvertible>(for key: String) -> T? {
        guard let components = URLComponents(string: self) else { return nil }
        guard let value = components.queryItems?.first(where: { $0.name == key })?.value else { return nil }
        return T(value)
    }
    
    var queryPage: Int? {
        queryValue(for: "page")
    }
}
