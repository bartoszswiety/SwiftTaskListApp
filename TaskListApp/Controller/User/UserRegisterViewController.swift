//
//  UserRegisterViewController.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class UserRegisterViewController: UIStackViewController, UITextFieldDelegate {
    let loginField: UITextField = {
        let field = UITextField()
        field.placeholder = "login"
        field.autocorrectionType = UITextAutocorrectionType.no
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .next
        field.setBottomBorder()
        field.backgroundColor = .systemBackground
        return field
    }()

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

    var registerButton: UIButton = {
        let btn = RoundButton(style: .blue)
        btn.setTitle("Register", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        title = "Register"
        super.viewDidLoad()
        makeView()
        stackView.alignment = .top
        navigationController!.setToolbarHidden(false, animated: true)
    }

    func makeView() {
        stackView.addArrangedSubview(loginField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(registerButton)

        loginField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        registerButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

        NSLayoutConstraint.activate([
            loginField.fullWidthConstraint(), loginField.heightConstraint(),
            emailField.fullWidthConstraint(), emailField.heightConstraint(),
            passwordField.fullWidthConstraint(), passwordField.heightConstraint(),
            registerButton.fullWidthConstraint(), registerButton.heightConstraint(),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1),
        ])
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tab = [loginField, emailField, passwordField]
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
        UserManager.shared.singup(name: loginField.text!, email: emailField.text!, password: passwordField.text!) { result, message in

            print(result)
            box.removeFromSuperview()

            switch result {
            case .fail:
                if message.contains("Password") {
                    self.passwordField.errorHighlight()
                }

                if message.contains("Name") {
                    self.loginField.errorHighlight()
                }

                if message.contains("Email") {
                    self.emailField.errorHighlight()
                }

            case .success:

                break
            }
        }
    }
}
