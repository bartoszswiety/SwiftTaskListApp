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

    public func singup(name: String, email: String, password: String, handler: @escaping ((API.RequestResult, String) -> Void)) {
        API.shared.provider.request(.singUP(name: name, email: email, password: password)) { result in
            switch result {
            case let .success(response):
                do {
                    print(try response.mapString())
                } catch {}
                let data = response.mapDictionary()

                if let message: String = data["message"] as? String {
                    if let key: String = data["auth_token"] as? String {
                        if key != "" {
                            self.user.email = email
                            self.user.login = name
                            self.user.access_key = key
                            handler(.success, message)
                            return
                        }
                    }
                    handler(.fail, message)
                    return
                } else {
                    handler(.fail, "Response JSON")
                }

            case .failure:
                handler(.fail, "")
            }
        }
    }
}

extension UserManager {
    var loggedIN: Bool {
        return user.access_key != ""
    }
}
