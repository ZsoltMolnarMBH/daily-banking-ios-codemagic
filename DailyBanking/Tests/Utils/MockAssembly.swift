//
//  MockAssembly.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 19..
//

import Foundation
import Resolver
import CoreData
@testable import DailyBanking

class AppAssemblyMock: Assembly {

    private static let objectModel: NSManagedObjectModel = {
        guard let mom = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else { fatalError("Failed to create mom") }
        return mom
    }()

    func assemble(container: Resolver) {
        container.register(NSPersistentContainer.self) {
            let container = NSPersistentContainer(name: "app-daily-banking", managedObjectModel: AppAssemblyMock.objectModel)
            let description = NSPersistentStoreDescription()

            description.url = URL(fileURLWithPath: "/dev/null")
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]

            container.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        .scope(container.cache)

        container.register {
            DeviceInformation(name: "TestCase's iPhone", model: "iPhone X", id: "123456789123456789")
        }.scope(container.cache)
    }
}
