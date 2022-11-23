//
//  UserStore+CoreData.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 08..
//
import Combine
import CoreData
import Foundation
import Resolver

class CoreDataUserStore: NSObject, UserStore {

    @Injected(container: .root) private var mapper: Mapper<UserEntity, User>

    private let stateSubject = CurrentValueSubject<User?, Never>(nil)
    var state: ReadOnly<User?> {
        ReadOnly<User?>(stateSubject: stateSubject)
    }

    private var fetchedResultsController: NSFetchedResultsController<UserEntity>?
    private let queue = DispatchQueue(label: "coredata.userstore", qos: .userInitiated)
    private let writeContext: NSManagedObjectContext
    private let readContext: NSManagedObjectContext

    init(persistentContainer: NSPersistentContainer) {
        readContext = persistentContainer.viewContext
        writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        writeContext.parent = readContext

        super.init()
        fetch()
    }

    private func fetch() {
        fetchedResultsController = UserEntity.fetchAll(
            sortedBy: [NSSortDescriptor(keyPath: \UserEntity.firstName, ascending: true)],
            delegate: self,
            context: readContext
        )
        let user = fetchedResultsController?.fetchedObjects?.first
        stateSubject.send(map(entity: user))
    }

    private func map(entity: UserEntity?) -> User? {
        guard let entity = entity else { return nil }
        return try? mapper.map(entity)
    }

    func modify(_ transform: @escaping (inout User?) -> Void) {
        queue.async(flags: .barrier) { [writeContext, stateSubject] in
            var copy = stateSubject.value
            transform(&copy)
            UserEntity.deleteAll(inContext: writeContext)
            if let user = copy {
                UserEntity.create(from: user, in: writeContext)
            }
            writeContext.saveToPersistentStore()
        }
    }
}

extension CoreDataUserStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let user = fetchedResultsController?.fetchedObjects?.first
        stateSubject.send(map(entity: user))
    }
}

private extension UserEntity {
    @discardableResult
    static func create(from domain: User, in context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity.init(context: context)
        entity.firstName = domain.name.firstName
        entity.lastName = domain.name.lastName
        entity.phoneNumber = domain.phoneNumber
        return entity
    }
}
