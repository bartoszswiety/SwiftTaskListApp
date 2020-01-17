//
//  Alerts.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 08/01/2020.
//  Copyright © 2020 Bartosz Swiety. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Shows warining prompt with OK and CANCEL
    /// - Parameter clickHandler: escaping when user interactied alert
    func presentWarningData(clickHandler: @escaping ((Bool) -> Void), message: String = "You will lost all not synced data.") {
        let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            clickHandler(false)
        }))

        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in

            clickHandler(true)
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
