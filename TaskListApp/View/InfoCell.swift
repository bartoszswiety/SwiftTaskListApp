//
//  DetailCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 22/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class InfoCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
//        label.backgroundColor = .blue
        return label
    }()

    var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
//        label.backgroundColor = .red
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(valueLabel)
        nameLabel.anchor(top: layoutMarginsGuide.topAnchor, left: layoutMarginsGuide.leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 0, enableInsets: false)

        valueLabel.anchor(top: layoutMarginsGuide.topAnchor, left: nameLabel.rightAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: layoutMarginsGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInfo(info: InfoCellData)
    {
        self.nameLabel.text = info.name + ":"
        self.valueLabel.text = info.value
    }
}
