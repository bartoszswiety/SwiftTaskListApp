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
//    MARK: Initalizers

    convenience init(title: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(-1, forKey: "id")
    }
}

extension Todo {
//    MARK: Preporties

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
//     MARK: Core Data Methods

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
//    MARK:Helpers

    public var todoItems: [TodoItem] {
        return (items?.allObjects as! [TodoItem]).sorted { (item1, item2) -> Bool in
            item1.created_at > item2.created_at
        }
    }

    public var doneItems: [TodoItem] {
        return todoItems.filter { (item) -> Bool in
            item.done
        }
    }

    func rename(title: String) {
        self.title = title
        setValue(title, forKey: "title")
        syncTitle()
    }

    func createItem() {
        addToItems(TodoItem(name: "unnamed", parent: self))
    }

    func removeItem(index: Int) {
        removeFromItems(todoItems[index])
        TodoManager.shared.save()
    }
}
