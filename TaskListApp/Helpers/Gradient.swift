//
//  Gradient.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit


extension UIView
{

    func createStyledGradient(colors: (UIColor, UIColor), radius: Float = 0, shadow: Bool = false) -> CAGradientLayer
    {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colors.0.cgColor, colors.1.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = CGFloat(radius)
        self.layer.addSublayer(gradient)

        if(shadow)
        {
            setShadow(radius: radius)
        }
        return gradient
    }

    private func setShadow(radius: Float = 0)
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
}
