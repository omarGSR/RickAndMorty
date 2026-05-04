//
//  Date+ext.swift
//  RickAndMorty
//
//  Created by silenGSR on 03/05/2026.
//

import Foundation

enum DateParserFormatter {
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    nonisolated static let prettyDate: DateFormatter = {
       let formatter = DateFormatter()
        formatter.locale = .current
        formatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return formatter
    }()
}
