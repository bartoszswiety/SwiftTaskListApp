//
//  UserManager.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
class UserManager {
    // MARK: - Preporties

    static var shared: UserManager = UserManager()
    var user: User = User.loadFromMemory()
    private var state = States.failed

    //MARK: Initalizers



}

extension UserManager {
    // MARK: - UserState

    /// RIght now we have only two states - let's treat not assigned user as Failed.
    public enum States {
        case failed // No access token, failed requests.
        case online // When all set up.
    }

    /// - returns: User state basing on access key
    var getState: States {
        if user.access_key == "" {
            return .failed // Temporary we treat not set user as failed.
        } else {
            return .online
        }
    }

    // MARK: - Error Catching

    /// Shouts about critical problems related with API
    /// Posts a need for new user loging
    public func invokeApiError() {
        print("on User error")
        NotificationCenter.default.post(name: .userError, object: nil)
    }
}

extension UserManager {
    // MARK: - User Managment methods

    /// Creates a new user and syncs it with Cloud
    /// - Parameter name: username
    /// - Parameter email: user email
    /// - Parameter password: user password (no encryption)
    public func singup(name: String, email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        API.request(target: .singUP(name: name, email: email, password: password), success: { _, data in
            if let message: String = data["message"] as? String {
                if let key: String = data["auth_token"] as? String {
                    if key != "" {
                        self.user.email = email
                        self.user.login = name
                        self.user.access_key = key
                        onSuccess()
                        return
                    }
                    else
                    {
                        onError("format")
                        return
                    }
                }
            }


        }, error: { _, message in
            print("shit" + message)
            onError(message)
            return

        }, userRequired: false)
    }
}
