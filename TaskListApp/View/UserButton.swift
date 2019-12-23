//
//  AddNavigationItem.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol UserButtonDelegate {
    func onClickUserButton()
}

class UserButton: UIButton {
    var delegate: UserButtonDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)

//        gradient = createStyledGradient(colors: (UIColor.systemBlue, UIColor.systemBlue), radius: 32, shadow: false)
        setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
//        createStyledGradient(colors: (UIColor.red, UIColor.white), radius: 0, shadow: false)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        imageView?.tintColor = .systemBlue
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    @objc func click() {
        delegate?.onClickUserButton()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gradient: CAGradientLayer?
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient?.frame = bounds
    }

    func show() {
        isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        })
    }

    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { ready in

            self.isHidden = ready
        }
    }
}
