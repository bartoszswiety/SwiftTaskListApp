//
//  TodoViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoItemsListViewController: AddButtonTableViewController {
    var todo: Todo?

    override func viewDidLoad() {
        title = "Todo"
        title = todo?.title
        tableView.allowsSelection = false
        navigationItem.largeTitleDisplayMode = .never

        super.viewDidLoad()
    }

    override func viewWillAppear(_: Bool) {
        if let navigation: TodoNavigationController = self.navigationController as? TodoNavigationController {
//            navigation.userButton.hide()
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todo?.removeFormItems(index: indexPath.item)
            tableView.reloadData(with: .fade)
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        todo?.itemsSorted.count ?? 0
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodoItemViewCell()
        cell.todoItem = todo?.itemsSorted[indexPath.item]
        return cell
    }

    override func onClickAddButton() {
        todo?.createItem()
        super.onClickAddButton()
    }
}
