//
//  UserManager.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
class UserManager {
    static var shared: UserManager = UserManager()
    var user: User = User.loadFromMemory()
    private var state = States.failed

    public func onApiError()
    {
        NotificationCenter.default.post(name: .userError, object: nil)
    }

    public func singup(name: String, email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        API.request(target: .singUP(name: name, email: email, password: password), success: { _, data in

            if let message: String = data["message"] as? String {
                if let key: String = data["auth_token"] as? String {
                    if key != "" {
                        self.user.email = email
                        self.user.login = name
                        self.user.access_key = key
                        self.user.save()
                        onError(message)
                    }
                }
            }
            onSuccess()
        }) { _, message in
            onError(message)
        }
    }
}

extension UserManager {
    public enum States {
        case failed //No access token, failed requests.
        case online
    }

    var getState: States {
        if user.access_key == "" {
            return .failed //Temporary we treat not set user as failed.
        } else {
            return state
        }
    }
}
