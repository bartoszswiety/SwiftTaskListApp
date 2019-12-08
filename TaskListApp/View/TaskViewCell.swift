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
        label.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(label)
        return label
    }()

    var checkButton: UIButton =
            {
            let button = UIButton()
//            button.backgroundColor = UIColor.systemBlue
            button.layer.cornerRadius = 50
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.systemBlue.cgColor
            return button
    }()


    @objc func OnCheckButton()
    {
        checkButton.backgroundColor = UIColor.systemBlue
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(checkButton)
        checkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: layoutMargins.top, paddingLeft: layoutMargins.left, paddingBottom: layoutMargins.bottom, paddingRight: layoutMargins.right, width: frame.size.height * 0.8, height: frame.size.height * 0.8, enableInsets: true)

        checkButton.layer.cornerRadius = frame.size.height * 0.4

        checkButton.addTarget(self, action: #selector(OnCheckButton), for: .touchUpInside)

        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: checkButton.leftAnchor, paddingTop: layoutMargins.top, paddingLeft: layoutMargins.left, paddingBottom: layoutMargins.bottom, paddingRight: 0, width: 0, height: frame.size.height, enableInsets: true)

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
