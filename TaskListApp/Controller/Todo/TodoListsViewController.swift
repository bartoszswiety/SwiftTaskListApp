//
//  TodoListsViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoListViewController: UITableViewController, AddButtonDelegate, TodoViewCellDelegate {
    let todoController: TodoManager = TodoManager.shared

    func onTodoClick(todo: Todo?) {
        let vc = TodoItemsListViewController()
        vc.todo = todo
        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoController.removeTodo(index: indexPath.item)
            tableView.reloadData(with: .fade)
        }
    }

    func onClickAddButton() {
        todoController.createTodo()
        if todoController.todos.count > 5 {
            todoController.dropAll()
        }
        tableView.reloadData(with: .fade)
    }

    override func viewDidAppear(_: Bool) {
        if let navigation: TodoNavigationController = self.navigationController as? TodoNavigationController {
            navigation.addButton.delegate = self
        }

        tableView.reloadData()
    }

    override func viewDidLoad() {
        title = "To Do"
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        todoController.todos.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoViewCell()
        cell.todo = todoController.todos[indexPath.item]
        cell.delegate = self
        return cell
    }

    @objc func addButonClicked() {
        TodoManager.shared.createTodo()
    }
}
