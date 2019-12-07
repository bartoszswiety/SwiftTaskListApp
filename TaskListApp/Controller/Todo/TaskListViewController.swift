//
//  TodoViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TasksLitViewController: UITableViewController
{
    let todoController = TodoController.shared

    override func viewDidLoad() {
        view.backgroundColor = .systemIndigo
        title = "Todo"
        todoController.addTask(title: "SIema")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoController.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TaskViewCell()
        cell.todo = todoController.todos[indexPath.item]
        return cell
    }
}
