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

    func getTodo(id: Int64) -> Todo? {
        return todos.first { (todo) -> Bool in
            todo.id == id
        }
    }

    func getIndex(item: Syncable) -> Int
    {
        if let todo = item as? Todo {
            return todos.firstIndex(of: todo) ?? -1
        }
        return -1
    }



    func remove(item: Syncable, sync: Bool = false)
    {
        if(sync)
        {
            var target: FlexHire?

            if let todo = item as? Todo {
                target = FlexHire.deleteTodo(id: todo.id.description)
                CoreDataStack.contex.delete(todo)
                todos.remove(at: getIndex(item: todo))
                save()
                //TODO: Check if items has been deleted - they should becasue of relation, but who knows what CoreData thinks ;)
            }

            if let todoItem = item as? TodoItem {
                target = FlexHire.deleteTodoItem(itemID: todoItem.id.description, parentID: todoItem.todo_id.description)
                todoItem.parent!.removeFromItems(todoItem)
                CoreDataStack.contex.delete(todoItem)
                save()
            }

            guard target != nil
                else {
                    print("ERROR")
                    return
            }

            API.request(target: target!, success: { _, _ in
                print("deleted")
                TodoManager.shared.save()
            }, error: { _, message in
                print(message)
            })
        }
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
        if (!item.isCreatedOnCloud) {
            // Todo has to be created on the Cloud.
            var target: FlexHire?

            var updated: Todo?
            if let todo = item as? Todo {
                target = FlexHire.addTodo(title: todo.title)
                updated = todo
            }

            if let todoItem = item as? TodoItem {
                target = FlexHire.addTodoItem(name: todoItem.title, parentID: String(todoItem.todo_id))
                updated = todoItem.parent
            }

            guard target != nil
                else {
                    print("ERROR")
                    return
            }

            API.request(target: target!, success: { _, dictionary in

                // We have to sync new Cloud Todo with local.

                updated?.set(dictionary: dictionary)
                item.setSyncTime()
                print("Synced")
            }, error: { _, message in
                print(message)
            })
            TodoManager.shared.save()
        }
        else
        {
            //Okay what if item exists?
            syncName(item: item)
        }
    }


    public func syncName(item: Syncable)
    {
        if item.isCreatedOnCloud {
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
            //We have to create it
            sync(item: item)
        }
    }

    public func syncDone(item: TodoItem) {
        //We really don't want to update a task which is not on the cloud.
        if(item.id > 0)
        {
            print(item.todo_id.description + " " + item.id.description)
            API.request(target: .updateTodoItem(parentID: item.todo_id.description, itemID: item.id.description, name: item.title, done: String(item.done)), success: { (result, data) in
                item.setSyncTime()
            }, error: { (result, error) in
                //TODO: Handle SyncDone Error
            })
        }
        else
        {
            sync(item: item)
            //TODO: Sync mark after adding item;
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
//                        existing.sync()
                    } else {
                        // Same name no tasks? Remove it.
                        remove(item: existing, sync: false)
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


extension TodoItem
{
    var parent: Todo? {
        return TodoManager.shared.getTodo(id: todo_id)
    }
}
