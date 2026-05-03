//
//  SwiftDataMigrationPlan.swift
//  Omar Fazal
//
//  Created by silenGSR on 19/01/26.
//

import SwiftData

enum SwiftDataMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SwiftDataSchemaV1.self,
        ]
    }

    static var stages: [MigrationStage] {
        [

        ]
    }
}
