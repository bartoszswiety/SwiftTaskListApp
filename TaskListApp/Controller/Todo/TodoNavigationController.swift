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

        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        hidesBottomBarWhenPushed = true

        NotificationCenter.default.addObserver(self, selector: #selector(onUserFailed(_:)), name: .userError, object: nil)
    }

    @objc func onUserFailed(_: Notification) {
        visibleViewController?.present(UserNavigationController(), animated: true, completion: nil)
    }
}
