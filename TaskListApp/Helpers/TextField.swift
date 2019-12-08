//
//  TextField.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func errorHighlight() {
        layer.shadowColor = UIColor.red.cgColor
    }

    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor

        layer.masksToBounds = false
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}
