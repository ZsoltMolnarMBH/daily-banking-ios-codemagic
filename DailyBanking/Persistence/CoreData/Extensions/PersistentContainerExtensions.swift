//
//  PersistentContainerExtensions.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 05..
//

import Foundation
import CoreData

extension NSPersistentContainer {
    var entityNames: [String] {
        managedObjectModel.entities.compactMap { $0.name }
    }

    func clearAllData() {
        entityNames.forEach { entityName in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try viewContext.executeAndMergeChanges(using: deleteRequest)
            } catch {
                print("CoreData -> There was an error clearing database")
            }
        }
    }
}
