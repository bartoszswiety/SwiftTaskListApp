//
//  UserNavigationController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

public class UserNavigationController: UINavigationController {
    public override func viewDidLoad() {
        let v = UserLandingViewController()
        setViewControllers([v], animated: true)

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.setTitleVerticalPositionAdjustment(200, for: .default)
        hidesBottomBarWhenPushed = true
        setToolbarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        print("push")
        super.pushViewController(viewController, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
}
