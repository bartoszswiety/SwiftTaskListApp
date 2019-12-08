//
//  AddNavigationItem.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol AddButtonDelegate
{
    func onClickAddButton()
}

class AddButton: UIButton
{
    var delegate: AddButtonDelegate? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("+", for: .normal)
        gradient = createStyledGradient(colors: (UIColor.systemBlue, UIColor.systemBlue), radius: 18, shadow: false)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    @objc func click()
    {
        delegate?.onClickAddButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gradient: CAGradientLayer? = nil
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient?.frame = self.bounds
    }

}
