//
//  Gradient.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createStyledGradient(colors: (UIColor, UIColor), radius: Float = 0, shadow: Bool = false, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colors.0.cgColor, colors.1.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = CGFloat(radius)
        layer.addSublayer(gradient)

        if shadow {
            setShadow(radius: radius)
        }
        return gradient
    }

    private func setShadow(radius _: Float = 0) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
}
