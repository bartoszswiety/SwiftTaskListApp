//
//  TodoViewCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol TodoViewCellDelegate {
    func onTodoClick(todo: Todo?)
}

class TodoViewCell: UITableViewCell, EditableTextDelegate {
    var delegate: TodoViewCellDelegate?

    func onClick() {
        delegate?.onTodoClick(todo: todo)
    }

    var todo: Todo? {
        didSet {
            if let todo = todo {
                cardView.setTitle(text: todo.title + todo.id.description)
            }
            if let data: Todo = todo {
                cardView.countsLabel.text = String(data.itemsDone.count) + "/" + String(data.itemsSorted.count)
            }
        }
    }

    func onTextEdited(text: String) {
        print(text)
        todo?.rename(title: text)
    }

    var cardView: CardView = CardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(cardView)
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: layoutMargins.top * 2, paddingLeft: layoutMargins.left, paddingBottom: layoutMargins.bottom * 2, paddingRight: layoutMargins.right, width: 0, height: 0, enableInsets: false)
        cardView.editableLabel.delegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
