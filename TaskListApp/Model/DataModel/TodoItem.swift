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
