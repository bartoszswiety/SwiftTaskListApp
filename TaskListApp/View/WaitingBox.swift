//
//  Loading.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import UIKit
public class WaitingBox: UIView {
    let logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle.grid.hex.fill")
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemGray4
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel(frame: frame)
        label.textColor = .white
        label.text = "Loading"
        label.textAlignment = .center

        addSubview(logoImage)
        let left: Int = Int(bounds.width * 0.5) - 50
        let top: Int = Int(bounds.height * 0.5) - 50
        logoImage.frame = CGRect(x: left, y: top, width: 100, height: 100)
        rotate()

        backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotate(duration: Double = 2) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2.0
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity

        logoImage.layer.add(rotationAnimation, forKey: "rotation")
    }
}

extension UIViewController {
    func createWaitingBox() -> WaitingBox {
        let box = WaitingBox(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(box)
        return box
    }
}
