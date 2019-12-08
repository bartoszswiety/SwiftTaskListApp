//
//  CardView.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit
class CardView: UIView
{
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)

        gradient = createStyledGradient(colors: (UIColor.init(named: "CardColorA")!, UIColor.init(named: "CardColorB")!), radius: 10, shadow: true)
        addSubview(countsLabel)
        countsLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: layoutMargins.bottom, paddingRight: layoutMargins.right * 2, width: 0, height: 50, enableInsets: false)
        addSubview(editableLabel)
        editableLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: layoutMargins.left, paddingBottom: 0, paddingRight: layoutMargins.right, width: 0, height: 50, enableInsets: false)
    }

    let countsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "4/10"
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        return lbl
    } ()

    let editableLabel: EditableText = {
        let lbl = EditableText(style: .whiteBold)
        lbl.setText(text: "Project")
        return lbl
    } ()

    func setTitle(text: String)
    {
        editableLabel.hideTextField()
        editableLabel.setText(text: text)
    }
    private var gradient: CAGradientLayer? = nil

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient?.frame = self.bounds
    }
}


