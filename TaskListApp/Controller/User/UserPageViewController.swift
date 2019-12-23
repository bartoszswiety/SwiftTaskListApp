//
//  UserPageViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 22/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class UserPageViewController: UITableViewController {
    var data: [Any] = [
        InfoCellData(name: "state", value: "Online"),

        InfoCellData(name: "login", value: UserManager.shared.user.login),
        InfoCellData(name: "email", value: UserManager.shared.user.email), ButtonCellData(title: "Logout"),
    ]

    override func viewDidLoad() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        data.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let info = data[indexPath.item] as? InfoCellData {
            let cell = InfoCell()
            cell.setInfo(info: info)
            return cell
        }
        if let button = data[indexPath.item] as? ButtonCellData {
            let cell = ButtonCell()
            cell.setButton(info: button)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension UserPageViewController: ButtonCellDelegate {
    func onCellButtonClick() {
        let alert = UIAlertController(title: "Are you sure?", message: "You will lost all not synced data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))

        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in
            UserManager.shared.logout() {
                if let delegtate: SceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    delegtate.reloadTodoNavigation()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
