//
//  SwiftDataManager.swift
//  Omar Fazal
//
//  Created by silenGSR on 19/01/26.
//

import SwiftData
import Foundation

final class SwiftDataManager {
    
    static let shared = SwiftDataManager()
    
    let container: ModelContainer
    
    @MainActor
    var context: ModelContext {
        container.mainContext
    }
    
    private init () {
        do {
            let storeURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
                .appending(path: "rm.store")
            
            let schema = Schema(versionedSchema: SwiftDataSchemaV1.self)
            
            let config = ModelConfiguration(
                schema: schema,
                url: storeURL
            )
            
            container = try ModelContainer(
                for: schema,
                migrationPlan: SwiftDataMigrationPlan.self,
                configurations: [config]
            )
            
        } catch {
            fatalError("Error creating SwiftData container: \(error)")
        }
    }
}
