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
        save()
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

    /// Drops all local `Todo` with synced Tag
    /// We can drop all synced mainly because they are stored on the cloud.
    func dropAllSynced() {
        todos.removeAll { (todo) -> Bool in
            !todo.isSynced
        }
        save()
    }

    /// Drops all local `Todo`
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
    public func sync(item: Syncable) {
        save()
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
                item.setSyncTime()
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
                item.setSyncTime()
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
        API.request(target: .todos, success: { result, _ in

            switch result {
            case let .success(response):

                do {
                    // Cloud todo are based on temporary Contex
                    var cloudTodo = try response.map([Todo].self)
                    self.merge(cloudTodos: cloudTodo)
                    self.save()
                    onSuccess()
                    return
                } catch { print("Can't map it")
                    onError()
                    return
                }

            case .failure: break
            }

            onError()
            return
        }, error: { _, _ in
            onError()
            return
        }, userRequired: true)
    }

    /// Merges cloud todos with local.
    /// - Parameter cloudTodos: <#cloudTodos description#>
    func merge(cloudTodos: [Todo]) {
        for todo in cloudTodos {
            if let existing: Todo = todos.first(where: { (x) -> Bool in
                x.title == todo.title
            }) {
                // Okay we have two tasks with the same name - what we should do?

                // Firstly let's check if it has been synced.
                if !existing.isSynced {
                    // That's really bad something with the same name and not synced.
                    if existing.itemsSorted.count > 0 {
                        // Even worse it has tasks...
                        // Let's sync it.
                        existing.sync()
                    } else {
                        // Same name no tasks? Remove it.
                        let index = todos.firstIndex(of: existing) ?? -1
                        if index > 0 {
                            removeTodo(index: index)
                        }
                    }
                }
            } else {
                print(todo.title)

                print(todo.created_at.description)

                for item in todo.itemsSorted {
                    CoreDataStack.contex.insert(item)
                }

                CoreDataStack.contex.insert(todo)

                todos.insert(todo, at: 0)
            }
        }
    }
}

extension Todo {
    // That's a core sync function which tries to add it and all it's not synced items.
    public func sync() {
        TodoManager.shared.sync(item: self)
        for item in itemsSorted {
            if !item.isSynced {
                TodoManager.shared.sync(item: item)
            }
        }
    }
}
