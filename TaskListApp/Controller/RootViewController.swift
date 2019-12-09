//
//  LoadingViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

public class RootViewController: UIViewController {
    let logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle.grid.hex.fill")
        view.contentMode = .scaleAspectFit
//        view.backgroundColor = .red
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func makeView() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImage)
        let left: Int = Int(view.bounds.width * 0.5) - 100
        let top: Int = Int(view.bounds.height * 0.5) - 100
        logoImage.frame = CGRect(x: left, y: top, width: 200, height: 200)
        rotate()
    }

    func rotate(duration: Double = 2) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2.0
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity

        logoImage.layer.add(rotationAnimation, forKey: "rotation")
    }

    public override func viewDidLoad() {
        makeView()

        if UserManager.shared.user.access_key == "" {
            showUser()
        } else {
//            API.shared.getTaskList { result, _ in
//                switch result {
//                case .success:
//                    self.showTasks()
//                case .fail:
//                    self.showUser()
//                }
//            }
        }
    }

    public override func viewDidAppear(_: Bool) {
        showUser()
    }

    func showUser() {
        let user = UserNavigationController()
        present(user, animated: true, completion: nil)
    }

    func showTasks() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = TaskAppNavigationViewController()
    }
}
