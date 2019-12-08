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
    var todo: Todo?

    override func viewDidLoad() {
        title = "Todo"
        title = todo?.title
        tableView.allowsSelection = false
    }

    override func viewDidAppear(_ animated: Bool) {
        if let navigation: TodoNavigationController = self.navigationController as? TodoNavigationController
        {
            navigation.addButton.delegate = self
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todo?.removeItem(index: indexPath.item)
            tableView.reloadData(with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todo?.todoItems.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = TodoItemViewCell()
        cell.todoItem = todo?.todoItems[indexPath.item]
        return cell
    }
}

extension TodoItemsListViewController: AddButtonDelegate
{
    func onClickAddButton() {
        todo?.createItem()
        tableView.reloadData(with: .automatic)
    }
}
