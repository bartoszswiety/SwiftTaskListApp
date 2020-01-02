//
//  TodoManager.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation
import UIKit

public class TodoManager: NSObject {
    // MARK: - Preporties

    public static var shared: TodoManager = TodoManager()
    public var todos: [Todo] = []

    // MARK: - Manager Initalizers

    public override init() {
        super.init()
        loadTodosFromCoreData()
    }

    /// Tries to load `Todo` from CoreData
    func loadTodosFromCoreData() {
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        do {
            todos = try CoreDataStack.contex.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension TodoManager {
    // MARK: - Todo lifecycle

    /// Creates a new local `Todo` and adds it to container.
    /// Instance is not saved in CoreData!
    /// Instance is not synced with Cloud!
    ///
    /// - returns: Todo 'unnamed' Instance
    func createTodo() -> Todo {
        let item = Todo(title: "unnamed")
        todos.insert(item, at: 0)
        return item
    }

    /// Removes `Todo` form container
    /// Change saved in CoreData&Sync
    ///
    /// - parameter index: `Todo` index in `.todos`
    func removeTodo(index: Int) {
        if let todo: Todo = self.todos[index] {
            do {
                CoreDataStack.contex.delete(todo)
            } catch { }
            todos.remove(at: index)
        }
        save()
    }

    /// Drops all local `TodoItems`
    /// Saved in CoreData
    /// Not synced with Cloud!
    func dropAll() {
        todos = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataStack.contex.execute(batchDeleteRequest)
            save()
        } catch {
            // Error Handling
        }
    }

    /// Saves all changes in CoreData
    func save() {
        do {
            try CoreDataStack.contex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension TodoManager {
    // MARK: -Syncing Local with Cloud.

    /// Synces `Syncable`  `title`  with Cloud.
    /// - Parameter item: `Syncable` item
    public func syncTitle(item: Syncable) {
        if item.isSynced {
            // Update
            var target: FlexHire?

            if let todo = item as? Todo {
                target = FlexHire.updateTodo(id: String(todo.id), title: todo.title)
            }

            if let todoItem = item as? TodoItem {
                target = FlexHire.updateTodoItem(parentID: String(todoItem.todo_id), itemID: String(todoItem.id), name: todoItem.title, done: "")
            }

            guard target != nil
                else {
                    print("ERROR")
                    return
            }

            API.request(target: target!, success: { _, _ in
                item.updateSyncTime()
                TodoManager.shared.save()
            }, error: { _, message in
                print(message)
            })
        } else {
            // Todo has to be created on the Cloud.
            var target: FlexHire?

            if let todo = item as? Todo {
                target = FlexHire.addTodo(title: todo.title)
            }

            if let todoItem = item as? TodoItem {
                target = FlexHire.addTodoItem(name: todoItem.title, parentID: String(todoItem.todo_id))
            }

            guard target != nil
                else {
                    print("ERROR")
                    return
            }

            API.request(target: target!, success: { _, dictionary in

                // We have to sync new Cloud Todo with local.
                item.set(dictionary: dictionary)
                print("Synced")
            }, error: { _, message in
                print(message)
            })
            TodoManager.shared.save()
        }
    }
}




extension TodoManager {
    // MARK: -Sync cloud with local

    func syncAll(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        API.request(target: .todos, success: { (result, dictionary) in
            print(dictionary)
            onSuccess()
        }, error: { (result, message) in
            onError()
            return
        }, userRequired: true)
    }
}
