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
            } catch {}
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

    /// Synces `Todo` `title`  with Cloud.
    /// - Parameter todo: `Todo`
    public func syncTitle(todo: Todo) {
        if todo.isSynced {
            // Update
            API.request(target: .updateTodo(id: String(todo.id), title: todo.title ?? ""), success: { _, _ in
                TodoManager.shared.save()
            }, error: { _, message in
                print(message)
            })
        } else {
            // Todo has to be created on the Cloud.
            API.request(target: .addTodo(title: todo.title ?? ""), success: { _, dictionary in

                // We have to sync new Cloud Todo with local.
                todo.set(dictionary: dictionary)

            }, error: { _, message in
                print(message)
            })
            TodoManager.shared.save()
        }
    }

    /// Synces `TodoItem` `name` with Cloud
    /// Creates a `TodoItem` on cloud if needed
    /// - Parameter todoItem: `TodoItem`
    func syncName(todoItem: TodoItem) {
        if todoItem.isSynced {
            // We can update
            API.request(target: .updateTodoItem(parentID: String(todoItem.todo_id), itemID: String(todoItem.id), name: todoItem.name, done: ""), success: { _, _ in

            }, error: { _, _ in
            })
        } else {
            // TodoItem has to be created on the Cloud
            API.request(target: .addTodoItem(name: todoItem.name, parentID: String(todoItem.todo_id)), success: { _, dictionary in

                // We have to sync new Cloud TodoItem with local data.
                todoItem.set(dictionary: dictionary)
            }, error: { _, _ in
            })
        }
    }

    /// Syncs `TodoItem` Done parameter with Cloud
    /// - Parameter todoItem: TodoItem
    func syncDone(todoItem: TodoItem) {
        API.request(target: .updateTodoItem(parentID: String(todoItem.todo_id), itemID: String(todoItem.id), name: "", done: String(todoItem.done)), success: { _, _ in

        }, error: { _, _ in
        })
    }
}

extension TodoManager {
    // MARK: -Sync cloud with local

    func syncAll(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        API.request(target: .todos,
                    success: { _, _ in
                        onSuccess()
                    }, error: { _, _ in
                        onError()
        })
    }
}
