//
//  TodoNavigationController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

public class TasksNavigationController: UINavigationController
{


    public override func viewDidLoad() {


        let v = TasksLitViewController()
        setViewControllers([v], animated: true)

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
        navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationBar.setTitleVerticalPositionAdjustment(200, for: .default)
        hidesBottomBarWhenPushed = true
        setToolbarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
}
