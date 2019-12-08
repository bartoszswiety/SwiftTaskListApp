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
    private let gradient: CAGradientLayer = CAGradientLayer()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setGradient()
        setShadow()
        addSubview(countsLabel)
        countsLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: layoutMargins.bottom, paddingRight: layoutMargins.right * 2, width: 0, height: 50, enableInsets: false)


        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: layoutMargins.left, paddingBottom: 0, paddingRight: layoutMargins.right, width: 0, height: 50, enableInsets: false)
    }

    let countsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "4/10"
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        return lbl
    } ()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Project"
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 30, weight: .bold)
        return lbl
    } ()

    func setGradient()
    {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 10
        self.layer.addSublayer(gradient)
    }

    func setShadow()
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }
}
