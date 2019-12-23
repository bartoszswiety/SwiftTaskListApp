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
/// Todo is a core class of  the App.
/// Todo is containted in CoreData and supports NSManagedObjects class.
///
/// Todo class is a container class for TodoItem objects.
/// Todo class has one required preporerty `title` which is needed for saving into CoreData.
/// Todo class which is not saved and not synced has `id` = -1

public class Todo: NSManagedObject {
//    MARK: - Initalizers

    convenience init(title: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(-1, forKey: "id")
    }
}

extension Todo {
//    MARK: -  Preporties

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var created_by: Int64
    @NSManaged public var id: Int64
    @NSManaged public var test: Float
    @NSManaged public var title: String?
    @NSManaged public var updated_at: Date?
    @NSManaged private var items: NSSet?
}

extension Todo {
//     MARK: - Core Data Methods

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: TodoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: TodoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
}

extension Todo {
//    MARK: - Helpers

    /// Checks if Todo has been synced basing on `id`
    public var isSynced: Bool {
        return id != -1
    }
}

extension Todo {
    // MARK: - Edit Methods

    /// Changes a title of the local Todo
    /// -Tries to synces  with Cloud
    func rename(title: String) {
        self.title = title
        setValue(title, forKey: "title")
        TodoManager.shared.syncTitle(todo: self)
    }
}

extension Todo {
    // MARK: - Item Managment

    /// Creates local unnamed `TodoItem` and adds to its container.
    /// new `TodoItem` is not synced with Cloud
    func createItem() -> TodoItem {
        let item = TodoItem(name: "unnamed", parent: self)
        addToItems(item)
        return item
    }

    /// Sorts `items` by `created_at` date DESC
    /// - returns: `[TodoItem]` form `items`
    public var itemsSorted: [TodoItem] {
        return (items?.allObjects as! [TodoItem]).sorted { (item1, item2) -> Bool in
            item1.created_at > item2.created_at
        }
    }

    /// Filters sorted `items` marked as `done`
    /// - returns: `[TodoItem]` marked as`done`
    public var itemsDone: [TodoItem] {
        return itemsSorted.filter { (item) -> Bool in
            item.done
        }
    }

    /// Removes the `TodoItem` from its container
    /// Change is saved&&synced with Cloud!
    ///
    /// - parameter index: Index of `TodoItem` in containe
    func removeFormItems(index: Int) {
        removeFromItems(itemsSorted[index])
        TodoManager.shared.save()
        // TODO: Sync Remove TodoItem
    }
}

extension Todo {
//    MARK: - Syncing CloudData with Local.

    /// Translates `dictionary` to `Todo` preporties.
    /// Change is not saved in CoreData!.
    /// - Parameter dictionary: with preporties names -
    /// ["id", "created_by","title","created-at","updated_at").
    func set(dictionary: [String: Any]) {
        if let id: Int64 = dictionary["id"] as? Int64 {
            self.id = id
        }

        if let created_by: Int64 = dictionary["created_by"] as? Int64 {
            self.created_by = created_by
        }

        if let title: String = dictionary["title"] as? String {
            self.title = title
        }

        if let created_at: Date = DateFormatter.date(string: dictionary["created_at"] as! String) {
            self.created_at = created_at
        }

        if let updated_at: Date = DateFormatter.date(string: dictionary["updated_at"] as! String) {
            self.updated_at = updated_at
        }
    }
}
