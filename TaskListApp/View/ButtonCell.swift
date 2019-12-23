//
//  ButtonCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 23/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonCellDelegate {
    func onCellButtonClick()
}

class ButtonCell: UITableViewCell {
    var delegate: ButtonCellDelegate?
    var button: RoundButton = {
        RoundButton(style: .blue(radius: 10))
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(button)
        button.anchor(top: layoutMarginsGuide.topAnchor, left: layoutMarginsGuide.leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: layoutMarginsGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onClick() {
        delegate?.onCellButtonClick()
    }

    func setButton(info: ButtonCellData) {
        button.setTitle(info.title, for: .normal)
    }
}
