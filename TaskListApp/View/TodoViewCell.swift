//
//  TodoViewCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoViewCell: UITableViewCell
{

    var cardView: CardView = CardView()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(cardView)
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: layoutMargins.top * 2, paddingLeft: layoutMargins.left, paddingBottom: layoutMargins.bottom * 2, paddingRight: layoutMargins.right, width: 0, height: frame.height, enableInsets: false)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
