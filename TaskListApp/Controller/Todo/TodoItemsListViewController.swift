//
//  TodoViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoItemsListViewController: UITableViewController
{
    let todoController = TodoController.shared

    override func viewDidLoad() {
        title = "Todo"
        todoController.addTask(title: "SIema")
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            self.tableArray.remove(at: indexPath.row)

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TaskViewCell()
        cell.todo = todoController.todos[indexPath.item]
        return cell
    }
}

