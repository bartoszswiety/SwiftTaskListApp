//
//  Notifications.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 21/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var userError: Notification.Name {
        return .init(rawValue: "APIUser.error")
    }

    static var userStateChanged: Notification.Name {
        return .init(rawValue: "APIUser.stateChanged")
    }
}
