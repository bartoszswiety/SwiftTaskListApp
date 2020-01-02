//
//  TodoListsViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoListViewController: AddButtonTableViewController {
    // MARK: Preporties

    let todoManager: TodoManager = TodoManager.shared
    var userButton: UIBarButtonItem?

    // MARK: viewDid

    override func viewDidLoad() {
        title = "To Do"
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        userButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(onClickUserButton))
        navigationItem.rightBarButtonItem = userButton

        loadApi()

        super.viewDidLoad()
    }

    override func viewDidAppear(_: Bool) {
        tableView.reloadData()
    }

    // MARK: ADD Button

    override func onClickAddButton() {
        TodoManager.shared.createTodo()
        super.onClickAddButton()
    }
}

extension TodoListViewController {
    // MARK: TableView

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        todoManager.todos.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoViewCell()
        cell.todo = todoManager.todos[indexPath.item]
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoManager.removeTodo(index: indexPath.item)
            tableView.reloadData(with: .fade)
        }
    }
}

extension TodoListViewController: TodoViewCellDelegate {
    // MARK: Click Delegates

    @objc func onClickUserButton() {
        print(UserManager.shared.getState)
        if UserManager.shared.getState != .failed {
            present(UserPageViewController(), animated: true, completion: nil)
            userButton?.tintColor = .systemBlue
        } else {
            // The best way to show user login is invoking error. It's very bad solution and should be temporary
            UserManager.shared.invokeApiError()
            // TODO: Show User Login without causing error
        }
    }

    func onTodoClick(todo: Todo?) {
        let vc = TodoItemsListViewController()
        vc.todo = todo
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoListViewController {
    // MARK: API

    func loadApi() {
        NotificationCenter.default.addObserver(self, selector: #selector(onUserStateChanged), name: .userStateChanged, object: nil)

        //We can try to sync with cloud - it's safe
        sync()
    }

    @objc func onUserStateChanged() {
        switch UserManager.shared.getState {
        case .failed:
            userButton?.tintColor = .gray
        case .online:
            userButton?.tintColor = .systemBlue
            sync()
        case .ready:
            userButton?.tintColor = .systemBlue
            sync()
        }
    }

    func sync() {
        let box = createWaitingBox()
        todoManager.syncAll(onSuccess: {
            self.tableView.reloadData(with: .fade)
            box.removeFromSuperview()
        }) {
            box.removeFromSuperview()
        }
    }
}
