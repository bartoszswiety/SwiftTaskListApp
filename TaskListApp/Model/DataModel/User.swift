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
                let user: User = try decoder.decode(User.self, from: data)
                return user
            } catch {}
        }
        return User()
    }

    public func save() {
        let data = (try! JSONEncoder().encode(self))
        print(data)
        UserDefaults().set(data, forKey: "user")
    }
}
