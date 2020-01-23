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
    case login(email: String, password: String)
    case todos
    case addTodo(title: String)
    case addTodoItem(name: String, parentID: String)
    case updateTodo(id: String, title: String)
    case updateTodoItem(parentID: String, itemID: String, name: String = "", done: String = "")
    case deleteTodo(id: String)
    case deleteTodoItem(itemID: String, parentID: String)
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
        case .login: return "auth/login"
        case .todos: return "todos"
        case .addTodo: return "todos"
        case let .updateTodo(id, title): return "todos/" + id
        case let .addTodoItem(name, parentID): return "todos/" + parentID + "/items"
        case let .updateTodoItem(parentID, itemID, name, done):
            return "todos/" + parentID + "/items/" + itemID
        case let .deleteTodo(id):
            return"todos/" + id
        case let.deleteTodoItem(itemID, parentID):
            return "todos/" + parentID + "/items/" + itemID
        }
    }

    public var method: Moya.Method {
        switch self {
        case .singUP: return .post
        case .login: return .post
        case .todos: return .get
        case .addTodo: return .post
        case .updateTodo: return .patch
        case .addTodoItem: return .post
        case .updateTodoItem: return .patch
        case .deleteTodo: return .delete
        case .deleteTodoItem: return .delete
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case let .addTodo(title):
            return .requestParameters(parameters: ["title": title], encoding: URLEncoding.queryString)
        case let .addTodoItem(name, parentID):
            return .requestParameters(parameters: ["name": name, "done": "false"], encoding: URLEncoding.queryString)
        case .todos:
            return .requestPlain
        case .deleteTodo:
            return .requestPlain
        case .deleteTodoItem:
            return .requestPlain
        case let .singUP(name, email, password):
            return .requestParameters(parameters: ["name": name, "email": email, "password": password, "password_confirmation": password], encoding: URLEncoding.queryString)
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: URLEncoding.queryString)
        case let .updateTodo(id, title):
            return .requestParameters(parameters: ["id": id, "title": title], encoding: URLEncoding.queryString)
        case let .updateTodoItem(parentID, itemID, name, done):
            var dictionary: [String: String] = [:]
            if name != "" {
                dictionary["name"] = name
            }
            if done != "" {
                dictionary["done"] = done
            }
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)

        }
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json",
                "Authorization": token]
    }
}
