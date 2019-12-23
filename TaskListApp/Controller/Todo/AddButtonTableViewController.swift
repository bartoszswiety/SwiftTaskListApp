//
//  AddButtonTableViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 22/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class AddButtonTableViewController: UITableViewController, AddButtonDelegate {
    let addButton: AddButton = AddButton()

    override func viewDidLoad() {
        showAddButton()
        super.viewDidLoad()
    }

    func showAddButton() {
        view.addSubview(addButton)
        addButton.anchor(top: nil, left: nil, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: view.layoutMargins.right, width: 64, height: 64, enableInsets: false)
        addButton.delegate = self
    }

    func onClickAddButton() {
        tableView.reloadData(with: .automatic)
    }
}
