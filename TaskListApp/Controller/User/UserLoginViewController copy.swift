//
//  UserRegisterViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class UserLoginViewController: UIStackViewController, UITextFieldDelegate {
    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "email"
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.setBottomBorder()
        field.backgroundColor = .systemBackground
        return field
    }()

    let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "password"
        field.returnKeyType = .send
        field.isSecureTextEntry = true
        field.clearButtonMode = .whileEditing
        field.setBottomBorder()
        field.backgroundColor = .systemBackground
        return field
    }()

    var loginButton: UIButton = {
        let btn = RoundButton(style: .blue)
        btn.setTitle("Login", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        title = "Login"
        super.viewDidLoad()
        makeView()
        stackView.alignment = .top
        navigationController!.setToolbarHidden(false, animated: true)
    }

    func makeView() {
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)

        emailField.delegate = self
        passwordField.delegate = self
        loginButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

        NSLayoutConstraint.activate([
            emailField.fullWidthConstraint(), emailField.heightConstraint(),
            passwordField.fullWidthConstraint(), passwordField.heightConstraint(),
            loginButton.fullWidthConstraint(), loginButton.heightConstraint(),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1),
        ])
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tab = [emailField, passwordField]
        var id = tab.firstIndex(of: textField)
        textField.resignFirstResponder()
        if id! < tab.count - 1 {
            tab[id! + 1].becomeFirstResponder()
        } else {
            submit()
        }
        return true
    }

    @objc func submit() {
        let box = createWaitingBox()
    }
}
