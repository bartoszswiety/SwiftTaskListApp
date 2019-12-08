//
//  UIButton.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    enum Style {
        case blue
        case green
    }

    private var gradient: CAGradientLayer?

    convenience init(style: Style) {
        self.init()
        switch style {
        case .blue:
            gradient = createStyledGradient(colors: (UIColor(named: "ButtonColorA")!, UIColor(named: "ButtonColorB")!), radius: 30, shadow: true)
            titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
            setTitleColor(.white, for: .normal)
        default:
            break
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient?.frame = bounds
    }
}
