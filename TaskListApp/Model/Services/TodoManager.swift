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

public class TodoController: NSObject
{
    public static var shared: TodoController = TodoController()
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

    func addTask(title: String)
    {
        self.todos.append(Todo(title: title))
        save()
    }

    func save()
    {
        do {
            try CoreDataStack.contex.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
