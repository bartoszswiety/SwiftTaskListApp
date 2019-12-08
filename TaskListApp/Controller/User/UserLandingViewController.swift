//
//  UserLandingViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class UserLandingViewController: UIStackViewController {

    var logoImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(systemName: "square.and.pencil")
        img.contentMode = .scaleAspectFit
        img.tintColor = .label
        return img
    }()

    var loginButton: UIButton = {
        let btn = RoundButton(style: RoundButton.Style.blue)
        btn.setTitle("Login", for: .normal)
        return btn
    }()

    var registerButton: UIButton = {
        let btn = RoundButton(style: RoundButton.Style.blue)
        btn.setTitle("Register", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        title = "Hello"
        super.viewDidLoad()
        makeView()
    }

    func makeView() {
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(registerButton)
        NSLayoutConstraint.activate([
            logoImage.fullWidthConstraint(),
            logoImage.heightConstraint(height: 220),
            loginButton.fullWidthConstraint(),
            registerButton.fullWidthConstraint(),
            loginButton.heightConstraint(),
            registerButton.heightConstraint(),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100)
        ])
        registerButton.addTarget(self, action: #selector(click), for: .touchUpInside)
        stackView.spacing = 20
        stackView.layoutIfNeeded()
    }

    @objc func click() {
//        navigationController?.pushViewController(UserRegisterViewController(), animated: true)
    }
}
