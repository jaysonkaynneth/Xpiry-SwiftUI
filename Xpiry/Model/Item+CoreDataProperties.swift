//
//  Item+CoreDataProperties.swift
//  Xpiry
//
//  Created by Jason Kenneth on 22/12/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var expiry: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var reminder: Int16
    @NSManaged public var stock: Int16

}

extension Item : Identifiable {

}
