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
        img.image = UIImage(systemName: "bolt.horizontal.icloud")
        img.contentMode = .scaleAspectFit
        img.tintColor = .systemGray3
        return img
    }()

    var loginButton: UIButton = {
        let btn = RoundButton(style: RoundButton.Style.blue(radius: 30))
        btn.setTitle("Login", for: .normal)
        return btn
    }()

    var registerButton: UIButton = {
        let btn = RoundButton(style: RoundButton.Style.blue(radius: 30))
        btn.setTitle("Register", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        title = "Flexhire Cloud"
        super.viewDidLoad()
        makeView()
    }

    func makeView() {
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginButton)
        NSLayoutConstraint.activate([
            logoImage.fullWidthConstraint(),
            logoImage.heightConstraint(height: 150),
            loginButton.fullWidthConstraint(),
            registerButton.fullWidthConstraint(),
            loginButton.heightConstraint(),
            registerButton.heightConstraint(),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
        ])

        loginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerClick), for: .touchUpInside)

        stackView.spacing = 20
        stackView.setCustomSpacing(50, after: logoImage)
        stackView.layoutIfNeeded()
    }

    @objc func loginClick() {
        navigationController?.pushViewController(UserLoginViewController(), animated: true)
    }

    @objc func registerClick() {
        navigationController?.pushViewController(UserRegisterViewController(), animated: true)
    }
}
