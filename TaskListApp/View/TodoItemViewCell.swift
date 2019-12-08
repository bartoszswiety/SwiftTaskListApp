//
//  TaskViewCell.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

class TodoItemViewCell: UITableViewCell {
    public var todoItem: TodoItem? {
        didSet {
            editableLabel.setText(text: todoItem?.name ?? "")
            showStatus()
        }
    }

    var editableLabel: EditableText = EditableText(style: .normal)

    var checkButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(checkButton)
        checkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: layoutMargins.top, paddingLeft: layoutMargins.left, paddingBottom: layoutMargins.bottom, paddingRight: layoutMargins.right * 2, width: 35, height: 0, enableInsets: true)
        checkButton.layer.cornerRadius = frame.size.height * 0.4
        checkButton.addTarget(self, action: #selector(onCheckButton), for: .touchUpInside)

        addSubview(editableLabel)
        editableLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: checkButton.leftAnchor, paddingTop: layoutMargins.top, paddingLeft: layoutMargins.left * 2, paddingBottom: layoutMargins.bottom, paddingRight: 0, width: 0, height: 0, enableInsets: true)
        editableLabel.delegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodoItemViewCell: EditableTextDelegate {
    func onTextEdited(text: String) {
        todoItem?.rename(name: text)
    }

    func onClick() {
        let alert = UIAlertController(title: "Details", message: "created:" + todoItem!.created_at.description, preferredStyle: .actionSheet)

        window?.rootViewController?.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @objc func onCheckButton() {
        if let done = self.todoItem?.done {
            todoItem!.mark(done: !done)
        }
        showStatus()
    }

    public func showStatus() {
        if let done = self.todoItem?.done {
            if done {
                checkButton.backgroundColor = UIColor.systemBlue
                editableLabel.alpha = 0.2
            } else {
                checkButton.backgroundColor = nil
                editableLabel.alpha = 1
            }
        }
    }
}
