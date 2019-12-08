//
//  TodoListsViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit


class TodoListViewController: UITableViewController
{

    override func viewDidLoad() {
//        view.backgroundColor = .systemIndigo
        title = "To Do"

        tableView.separatorStyle = .none


    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(TodoItemsListViewController(), animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TodoViewCell()
//        cell.todo = todoController.todos[indexPath.item]
        return cell
    }
}
