//
//  ManagedObject.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 05..
//

import Foundation
import CoreData

protocol ManagedObject {}

extension NSManagedObject: ManagedObject {}

extension ManagedObject where Self: NSManagedObject {
    static func entityName() -> String {
        return String(describing: self)
    }

    static func createFetchRequest(predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName())
        fetchRequest.predicate = predicate

        return fetchRequest
    }

    static func execute(
        fetchRequest: NSFetchRequest<Self>,
        inContext context: NSManagedObjectContext
    ) -> [Self]? {

        var result: [Self]?
        context.performAndWait {
            do {
                try result = context.fetch(fetchRequest)
            } catch let error {
                print("CoreData -> Fetch error: \(error)")
            }
        }

        return result
    }

    static func findAll(
        with predicate: NSPredicate? = nil,
        sortedBy: [NSSortDescriptor] = [],
        inContext context: NSManagedObjectContext
    ) -> [Self]? {
        let fetchRequest: NSFetchRequest<Self> = createFetchRequest(predicate: predicate)
        fetchRequest.sortDescriptors = sortedBy
        return execute(fetchRequest: fetchRequest, inContext: context)
    }

    static func count(
        with predicate: NSPredicate? = nil,
        inContex context: NSManagedObjectContext
    ) -> Int {

        let eName = String(describing: self)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: eName)
        request.predicate = predicate
        do {
            return try context.count(for: request)
        } catch {
            print("CoreData -> count failed: \(error)")
            return 0
        }
    }

    @discardableResult
    static func delete(
        withPredicate predicate: NSPredicate,
        inContext context: NSManagedObjectContext
    ) -> Int {

        let fetchRequest = createFetchRequest(predicate: predicate)
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = false

        var count = 0
        let objectsToDelete = execute(fetchRequest: fetchRequest, inContext: context)
        objectsToDelete?.forEach({ object in
            context.delete(object)
            count += 1
        })

        return count
    }

    static func fetchAll(
        withPredicate predicate: NSPredicate? = nil,
        sortedBy: [NSSortDescriptor],
        delegate: NSFetchedResultsControllerDelegate?,
        faulting: Bool = true,
        context: NSManagedObjectContext
    ) -> NSFetchedResultsController<Self> {

        let fetchRequest = createFetchRequest(predicate: predicate)
        fetchRequest.returnsObjectsAsFaults = faulting
        fetchRequest.sortDescriptors = sortedBy

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        fetchedResultsController.delegate = delegate

        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("CoreData -> fetchAll failed: \(error)")
        }

        return fetchedResultsController
    }

    @discardableResult
    static func deleteAll(inContext context: NSManagedObjectContext) -> Int {
        var count = 0
        let objectsToDelete = findAll(inContext: context)
        objectsToDelete?.forEach({ object in
            context.delete(object)
            count += 1
        })

        return count
    }
}
