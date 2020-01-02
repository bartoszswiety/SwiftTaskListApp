//
//  TodoItem.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation

@objc(TodoItem)
/// TodoItem is a `Todo` item with additinal  `done` feature.
///
/// Although TodoItem is very similiar to Todo Parent it couldn't be subclassed, so we have to treat and define it seperatly mainly becasue of CloudData and NSManagedObject. Most of class limits are defined by FlexHire API backend.
///
/// TodoItem can't exists without `Todo` parent which is reflected by `parent_id`

public class TodoItem: Syncable {
    // MARK: - Initalizer

    convenience init(title: String, parent: Todo) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(-1, forKey: "id")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(parent.id, forKey: "todo_id")
    }

}

extension TodoItem {
    // MARK: - Preporties

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var done: Bool

    /// Reflects TODO parent
    @NSManaged public var todo_id: Int64
}

extension TodoItem {
    // MARK: - Edit Methods

    /// Changes a title of the local Todo
    /// -Tries to synces  with Cloud

    public func mark(done: Bool = true) {
        self.done = done
        setValue(done, forKey: "done")
        TodoManager.shared.save()
        // TODO: sync done
    }
}
