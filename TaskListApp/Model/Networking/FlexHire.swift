//
//  FlexHire.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import Moya

public enum FlexHire {
    case singUP(name: String, email: String, password: String)
    case todos
}

extension FlexHire: TargetType {
    public var baseURL: URL { return URL(string:
        "https://todos.flexhire.com/")! }

    public var token: String {
        return UserManager.shared.user.access_key
    }

    public var path: String {
        switch self {
        case .singUP: return "signup"
        case .todos: return "todos"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .singUP: return .post
        case .todos: return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .todos:
            return .requestPlain

        case let .singUP(name, email, password):

            return .requestParameters(parameters: ["name": name, "email": email, "password": password, "password_confirmation": password], encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json",
                "Authorization": token]
    }
}
