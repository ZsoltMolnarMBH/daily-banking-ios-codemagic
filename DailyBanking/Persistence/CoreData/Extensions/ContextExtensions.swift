//
//  ContextExtensions.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 05..
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveToPersistentStore() {
        performAndWait {
            if self.hasChanges {
                defer {
                    parent?.saveToPersistentStore()
                }
                do {
                    try self.save()
                } catch {
                    fatalError("NSManagedObjectContext -> \(error.localizedDescription)")
                }
            }
        }
    }

    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
