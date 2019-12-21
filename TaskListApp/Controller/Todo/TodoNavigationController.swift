//
//  TodoNavigationController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

public class TodoNavigationController: UINavigationController {
    public override func viewDidLoad() {
        let v = TodoListViewController()
        setViewControllers([v], animated: true)
        view.backgroundColor = .systemIndigo

        navigationBar.prefersLargeTitles = true
        hidesBottomBarWhenPushed = true
        setToolbarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        createAddButton()

        NotificationCenter.default.addObserver(self, selector: #selector(onUserFailed(_:)), name: .userError, object: nil)
    }

    @objc func onUserFailed(_: Notification) {
        visibleViewController?.present(UserNavigationController(), animated: true, completion: nil)
    }

    let addButton: AddButton = AddButton()
    func createAddButton() {
        if let navigationBar: UINavigationBar = navigationBar {
            navigationBar.addSubview(addButton)
            addButton.anchor(top: nil, left: nil, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: navigationBar.layoutMargins.bottom, paddingRight: navigationBar.layoutMargins.right * 2, width: 35, height: 35, enableInsets: true)
//            addButton.delegate = self
        }
    }
}
