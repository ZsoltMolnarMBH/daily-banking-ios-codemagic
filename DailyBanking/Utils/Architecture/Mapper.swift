//
//  Mapper.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 14..
//

import Foundation
import CoreData

class Mapper<Source, Product> {
    func map(_ item: Source) throws -> Product {
        fatalError("Override required!")
    }

    final func map(_ items: [Source]) throws -> [Product] {
        return try items.map { try self.map($0) }
    }

    final func compactMap(_ items: [Source]) -> [Product] {
        return items.compactMap { try? self.map($0) }
    }

    final func makeError(item: Source, reason: String) -> MapperError {
        MapperError(item: item, sourceType: Source.self, productType: Product.self, reason: reason)
    }
}

class CoreDataMapper<Source, Product: NSManagedObject> {

    @discardableResult
    func map(_ item: Source, in context: NSManagedObjectContext) -> Product {
        fatalError("Override required!")
    }

    @discardableResult
    final func map(_ items: [Source], in context: NSManagedObjectContext) -> [Product] {
        items.map { map($0, in: context) }
    }
}

struct MapperError: Swift.Error, CustomStringConvertible {
    let item: Any
    let sourceType: Any
    let productType: Any
    let reason: String

    var description: String {
        """
        Mapping failed (\(sourceType) -> \(productType))
        item: \(item)
        reason: \(reason)
        """
    }
}
