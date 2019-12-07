//
//  TaskViewCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TaskViewCell: UITableViewCell
{
    var titleLabel: UILabel = {
        let label = UILabel()
//        addSubview(label)
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: layoutMargins.left, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: frame.size.height, enableInsets: true)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var todo: Todo?
    {
        didSet
        {
            titleLabel.text = todo?.title
        }
    }

}
