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

public class TodoItem: Syncable, Decodable {
    // MARK: - Initalizer

    convenience init(title: String, parent: Todo) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(-1, forKey: "id")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(parent.id, forKey: "todo_id")
    }

    /// Decodes in Temporary Controller.`
    /// - Parameter decoder: <#decoder description#>
    public required convenience init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: CoreDataStack.contex)!, insertInto: nil)

        let values = try decoder.container(keyedBy: CodingKeys.self)

        try set(values: values)
    }

    public override func set(values: KeyedDecodingContainer<Syncable.CodingKeys>) throws {
        synced_at = Date()
        try super.set(values: values)

        todo_id = try values.decode(Int64.self, forKey: .todo_id)
        title = try values.decode(String.self, forKey: .name)

        done = false
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
//        self.done = done
        setValue(done, forKey: "done")
        TodoManager.shared.syncDone(item: self)
//        TodoManager.shared.save()
        // TODO: sync done
    }
}
