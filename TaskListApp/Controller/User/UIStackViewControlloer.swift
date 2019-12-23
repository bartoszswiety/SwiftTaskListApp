//
//  UIStackViewControlloer.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class UIStackViewController: UIViewController {
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10.0
        return stack
    }()

    override func viewWillAppear(_: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.hidesBottomBarWhenPushed = true

        let layout = view.layoutMarginsGuide
        var constraints = [stackView.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
                           stackView.fullWidthConstraint()]
        NSLayoutConstraint.activate(constraints)
    }
}
