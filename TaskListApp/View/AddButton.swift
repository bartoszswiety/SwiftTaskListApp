//
//  AddNavigationItem.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol AddButtonDelegate {
    func onClickAddButton()
}

class AddButton: UIButton {
    var delegate: AddButtonDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("+", for: .normal)
        gradient = createStyledGradient(colors: (UIColor.systemBlue, UIColor.systemBlue), radius: 32, shadow: false)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    @objc func click() {
        delegate?.onClickAddButton()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gradient: CAGradientLayer?
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient?.frame = bounds
    }
}
