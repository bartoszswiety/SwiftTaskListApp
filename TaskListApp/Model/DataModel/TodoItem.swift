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
public class TodoItem: NSManagedObject {
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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var created_at: Date
    @NSManaged public var done: Bool
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var todo_id: Int64
    @NSManaged public var updated_at: Date
    @NSManaged public var todo: Todo
}

extension TodoItem {


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

    func syncTitle()
    {
        if(id == -1)
        {
            //ADD
            API.request(target: .addTodoItem(name: self.name, parentID: String(self.todo_id)), success: { (result, dictionary) in
                self.set(dictionary: dictionary)
            }) { (result, message) in

            }
        }

    }


    public func rename(name: String) {
        self.name = name
        setValue(name, forKey: "name")
        TodoManager.shared.save()
        syncTitle()
    }

    public func mark(done: Bool = true) {
        self.done = done
        setValue(done, forKey: "done")
        TodoManager.shared.save()
    }
}
