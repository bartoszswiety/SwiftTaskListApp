//
//  TodoItem.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import Foundation
import CoreData

@objc(TodoItem)
public class TodoItem: NSManagedObject {
    convenience init(name: String)
    {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        self.setValue(name, forKey: "name")
    }
}

extension TodoItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var done: Bool
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var todo_id: Int64
    @NSManaged public var updated_at: Date?
    @NSManaged public var todo: Todo?

}

extension TodoItem
{
    public func rename(name: String)
    {
        self.name = name
        setValue(name, forKey: "name")
        TodoManager.shared.save()
    }

    public func mark(done: Bool = true)
    {
        self.done = done
        setValue(done, forKey: "done")
        TodoManager.shared.save()
    }
}
