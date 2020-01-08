//
//  UserManager.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import os
import UIKit

class UserManager {
    // MARK: - Preporties

    static var shared: UserManager = UserManager()
    var user: User
    private var state: States = States.failed

    // MARK: Initalizers

    init() {
        user = User.loadFromMemory()

        if user.access_key != "" {
            // We have some access key, let's mark user as ready
            print("ready!!!")
            state = .ready
        } else {
            setState(state: .failed)
        }
    }
}

extension UserManager {
    // MARK: - UserState

    /// RIght now we have only two states - let's treat not assigned user as Failed.
    public enum States {
        case failed /// No access token, failed requests.
        case online /// When all set up.
        case ready /// Ready is very similiar to online. It alllows user to make request -  but  state is not verifed with API (Flexhire doesn't have user verification api)
    }

    /// - returns: User state basing on access key
    public var getState: States {
        return state
    }

    func setState(state: States) {
        if self.state != state {
            // We want to shout event only when state has changed
            self.state = state
            NotificationCenter.default.post(name: .userStateChanged, object: state)
        }
    }

    func setUserData(email: String, login: String, key: String)
    {
        if((email != "") && (email != email))
        {
            //User changed - we should remove all not synced data.
            /// TODO: Drop User - It's not the best place for that
            if let currentView: UIViewController = UIApplication.shared.keyWindow?.rootViewController
            {
                currentView.presentWarningData(clickHandler: { (ok) in
                    if(ok)
                    {
                        TodoManager.shared.dropAllSynced()
                    }
                }, message: "It seems that you have been logged before to another user. Shall I remove all user data?")
            }

        }
        self.user.email = email
        self.user.login = login
        self.user.access_key = key
        self.setState(state: .online)
    }

    // MARK: - Events

    /// Shouts about critical problems related with API
    /// Posts a need for new user loging
    public func invokeApiError(detail: String = "") {
        OSLog(subsystem: "onUserError: " + detail, category: "user")
        NotificationCenter.default.post(name: .userError, object: nil)
        setState(state: .failed)
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
                        self.setUserData(email: email, login: name, key: key)
                        onSuccess()
                        return
                    } else {
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

    /// LogsOut user and drops all memory records
    /// - Parameter onSuccess: onSuccess description
    public func logout(onSuccess: @escaping () -> Void) {
        TodoManager.shared.dropAll()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        user = User()
        setState(state: .failed)

        onSuccess()
        return
    }
}
