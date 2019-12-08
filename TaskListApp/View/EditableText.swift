//
//  EditableText.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

protocol EditableTextDelegate
{
    func onTextEdited(text: String)
    func onClick()
}

class EditableText: UIView, UITextFieldDelegate
{

    public static var singleton: EditableText? = nil

    var delegate: EditableTextDelegate? = nil
    var text: String = ""
    private var button: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.anchor(top: btn.topAnchor, left: btn.leftAnchor, bottom: btn.bottomAnchor, right: btn.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        return btn
    }()

    private var textField: UITextField?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 27, weight: .bold)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        button.addGestureRecognizer(longGesture)
    }
    func enterMode()
    {

        EditableText.singleton?.hideTextField()
        EditableText.singleton = self
        button.isHidden = true
        createTextField()
    }

    @objc func onButtonClick()
    {
        if(EditableText.singleton != self)
        {
            delegate?.onClick()
        }
    }
    @objc func onLongPress()
    {
        if(EditableText.singleton != self)
        {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
            enterMode()
        }
    }

    private func createTextField()
    {
        print("nyc")
        textField = UITextField()
        button.isHidden = true
        addSubview(textField!)
        textField?.text = text
        textField?.placeholder = "Enter Name"
        textField?.returnKeyType = .done
        textField?.becomeFirstResponder()
        textField?.delegate = self
        textField?.textColor = .systemGray
        textField?.font = .systemFont(ofSize: 27, weight: .bold)
        textField!.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }

    func hideTextField()
    {
        self.textField?.removeFromSuperview()
        button.isHidden = false
        self.textField = nil

        EditableText.singleton = nil
    }
    func setText(text: String)
    {
        if(text == "unnamed")
        {
            setText(text: "")
            enterMode()
        }

        self.text = text
        button.setTitle(text, for: .normal)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        setText(text: textField.text!)
        print("done")
        textField.resignFirstResponder()
        hideTextField()
        delegate?.onTextEdited(text: text)
        return true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
