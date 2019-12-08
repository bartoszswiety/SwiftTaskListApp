//
//  TodoListsViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit


class TodoListViewController: UITableViewController, AddButtonDelegate, TodoViewCellDelegate
{

    let todoController: TodoManager = TodoManager.shared
    func onTodoClick(todo: Todo?) {
        self.navigationController?.pushViewController(TodoItemsListViewController(), animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoController.deleteTodo(index: indexPath.item)
            tableView.reloadData(with: .fade)
        }
    }

    func onClickAddButton() {
        todoController.createTodo()
        if(todoController.todos.count > 5)
        {
            todoController.dropAll()
        }
        tableView.reloadData(with: .fade)
    }


    let addButton: AddButton = AddButton()

    override func viewDidLoad() {
//        view.backgroundColor = .systemIndigo
        title = "To Do"

        tableView.separatorStyle = .none
//        let barBtnVar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButonClicked))

        if let navigationBar: UINavigationBar = navigationController?.navigationBar
        {
            navigationBar.addSubview(addButton)
            addButton.anchor(top: nil, left: nil, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: navigationBar.layoutMargins.bottom, paddingRight: navigationBar.layoutMargins.right * 2, width: 35, height: 35, enableInsets: true)
            addButton.delegate = self
        }

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoController.todos.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TodoViewCell()
        cell.todo = todoController.todos[indexPath.item]
        cell.delegate = self
        return cell
    }

    @objc func addButonClicked()
    {
        TodoManager.shared.createTodo()
    }


}
