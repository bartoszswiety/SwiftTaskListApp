//
//  TodoManager.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class TodoManager: NSObject
{
    public static var shared: TodoManager = TodoManager()
    public var todos: [Todo] = []

    public override init() {
        super.init()
        self.loadTodosFromCoreData()
    }

    func loadTodosFromCoreData()
    {
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        do
        {
            todos = try CoreDataStack.contex.fetch(request)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func deleteTodo(index: Int)
    {
        if let todo: Todo = self.todos[index]
        {
            todo.prepareForDeletion()
            todos.remove(at: index)
        }
        save()
    }

    func createTodo()
    {
        self.todos.insert(Todo(title: "unnamed"), at: 0)
        save()
    }

    func dropAll()
    {
        todos = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")


        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataStack.contex.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }

    }

    func save()
    {
        do {
//            CoreDataStack.contex.c
            try CoreDataStack.contex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
