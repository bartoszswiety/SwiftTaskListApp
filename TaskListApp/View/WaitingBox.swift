//
//  Loading.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import UIKit
public class WaitingBox: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel(frame: frame)
        label.textColor = .white
        label.text = "Loading"
        label.textAlignment = .center
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func createWaitingBox() -> WaitingBox {
        let box = WaitingBox(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(box)
        return box
    }
}
