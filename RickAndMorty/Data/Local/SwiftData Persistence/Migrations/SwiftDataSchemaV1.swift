//
//  SwiftDataSchemaV1.swift
//  Omar Fazal
//
//  Created by silenGSR on 19/01/26.
//

import SwiftData

enum SwiftDataSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [
    //        CharacterEntity.self,
    //        PageInfoEntity.self
        ]
    }
}
