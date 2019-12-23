//
//  User.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

public class User: Codable {
    public var access_key: String = "elo" {
        didSet {
            save()
        }
    }

    public var email: String = ""
    public var login: String = ""
}

extension User {
    public static func loadFromMemory() -> User {
        let decoder = JSONDecoder()

        if let data = UserDefaults().data(forKey: "user") {
            do {
                print(data)
                let user: User = try decoder.decode(User.self, from: data)
                print("email" + user.email)
                return user
            } catch { }
        } else {
            print("no user first run ")
        }
        return User()
    }

    public func save() {
        print(access_key)
        let data = (try! JSONEncoder().encode(self))
        print(data)
        UserDefaults().set(data, forKey: "user")
    }
}

extension User
{


}
