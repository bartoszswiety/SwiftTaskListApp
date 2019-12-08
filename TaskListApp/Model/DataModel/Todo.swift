//
//  TaskModel.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {


    convenience init(title: String)
    {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        self.setValue(title, forKey: "title")
    }
}

extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var createdBy: Int64
    @NSManaged public var id: Int64
    @NSManaged public var test: Float
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
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

extension Todo
{
    func rename(title: String)
    {
        self.title = title
        setValue(title, forKey: "title")
        TodoManager.shared.save()
    }
}
