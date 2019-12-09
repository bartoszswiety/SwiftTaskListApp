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
    public static var shared: TodoManager = TodoManager()
    public var todos: [Todo] = []

    public func sync(handler: @escaping ((API.RequestResult, API.SyncResultMessage) -> Void)) {
        if UserManager.shared.getState == .noAccessToken {
            return handler(.fail, .user)
        } else {
            print("git")
            print(UserManager.shared.user.access_key)
            API.shared.provider.request(.todos) { result in
                switch result {
                case let .success(response):

                    print(try! response.mapString())

                case let .failure(error):
                    print(error)
                    return handler(.fail, .user)
                }
            }
        }
    }

    public override init() {
        super.init()
        loadTodosFromCoreData()
    }

    func loadTodosFromCoreData() {
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        do {
            todos = try CoreDataStack.contex.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func removeTodo(index: Int) {
        if let todo: Todo = self.todos[index] {
            do {
                CoreDataStack.contex.delete(todo)
            } catch {}
            todos.remove(at: index)
        }
        save()
    }

    func createTodo() {
        todos.insert(Todo(title: "unnamed"), at: 0)
    }

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

    func save() {
        do {
//            CoreDataStack.contex.c
            try CoreDataStack.contex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension Todo {
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

    public func sync() {
        if id != -1 {
            // Update
        } else {
            API.shared.provider.request(.addTodo(title: title ?? "")) { result in
                switch result {
                case let .success(response):
                    do {
                        print(try! response.mapString())
                        self.set(dictionary: response.mapDictionary())
                    } catch let error as NSError {
                        print("Could not sync. \(error), \(error.userInfo)")
                    }
                case .failure:
                    break
                }
            }
        }
        TodoManager.shared.save()
    }

    public var todoItems: [TodoItem] {
        return (items?.allObjects as! [TodoItem]).sorted { (item1, item2) -> Bool in
            item1.created_at > item2.created_at
        }
    }

    public var doneItems: [TodoItem] {
        return todoItems.filter { (item) -> Bool in
            item.done
        }
    }

    func rename(title: String) {
        self.title = title
        setValue(title, forKey: "title")
        sync()
    }

    func createItem() {
        addToItems(TodoItem(name: "unnamed"))
        TodoManager.shared.save()
    }

    func removeItem(index: Int) {
        removeFromItems(todoItems[index])
        TodoManager.shared.save()
    }
}
