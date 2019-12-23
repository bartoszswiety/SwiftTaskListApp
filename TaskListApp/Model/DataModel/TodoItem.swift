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
/// Although TodoItem is very similiar to Todo Parent we have to treat and define it seperatly mainly becasue of CloudData and NSManagedObject. Most of class limits are defined by FlexHire API backend.
///
/// TodoItem can't exists without `Todo` parent which is reflected by `parent_id`

public class TodoItem: NSManagedObject {
    // MARK: - Initalizer

    convenience init(name: String, parent: Todo) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(name, forKey: "name")
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

    @NSManaged public var created_at: Date
    @NSManaged public var done: Bool
    @NSManaged public var id: Int64
    @NSManaged public var name: String

    /// Reflects TODO parent
    @NSManaged public var todo_id: Int64
    @NSManaged public var updated_at: Date
    @NSManaged public var todo: Todo
}

extension TodoItem {
//    MARK: - Helpers

    /// Checks if Todo has been synced basing on `id`
    public var isSynced: Bool {
        return id != -1
    }
}

extension TodoItem {
    // MARK: - Edit Methods

    /// Changes a title of the local Todo
    /// -Tries to synces  with Cloud
    public func rename(name: String) {
        self.name = name
        setValue(name, forKey: "name")
        TodoManager.shared.save()
        TodoManager.shared.syncName(todoItem: self)
    }

    public func mark(done: Bool = true) {
        self.done = done
        setValue(done, forKey: "done")
        TodoManager.shared.save()
        // TODO: sync done
    }
}

extension TodoItem {
    //    MARK: - Syncing CloudData with Local.

    /// Translates `dictionary` to `TodoItem` preporties.
    /// Change is not saved in CoreData!.
    /// - Parameter dictionary: with preporties names -
    /// ["id","name","created-at","updated_at").
    func set(dictionary: [String: Any]) {
        if let id: Int64 = dictionary["id"] as? Int64 {
            self.id = id
        }
        if let name: String = dictionary["name"] as? String {
            self.name = name
        }

        if let created_at: Date = DateFormatter.date(string: dictionary["created_at"] as! String) {
            self.created_at = created_at
        }

        if let updated_at: Date = DateFormatter.date(string: dictionary["updated_at"] as! String) {
            self.updated_at = updated_at
        }
    }
}
