//
//  TaskModel.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation
import Moya

@objc(Todo)
public class Todo: NSManagedObject {
    convenience init(title: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(-1, forKey: "id")
    }
}

extension Todo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var created_by: Int64
    @NSManaged public var id: Int64
    @NSManaged public var test: Float
    @NSManaged public var title: String?
    @NSManaged public var updated_at: Date?
    @NSManaged public var items: NSSet?
}

extension Todo {
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: TodoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: TodoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
}
