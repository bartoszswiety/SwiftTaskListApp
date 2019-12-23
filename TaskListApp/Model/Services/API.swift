//
//  API.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation
import Moya
import Result

public class API {
    // MARK: - Preporties

    public static var shared: API = API()
    public let provider = MoyaProvider<FlexHire>()

    // MARK: Initalizer

    init() {
        print(UserManager.shared.user.email)
    }
}

extension API {
    // MARK: - Helpers

    public typealias SuccessCallback = (_ result: Result<Moya.Response, MoyaError>, _ dictionary: [String: Any]) -> Void
    public typealias ErrorCallback = (_ result: Result<Moya.Response, MoyaError>, _ message: String) -> Void

    // MARK: - Cloud Requesting

    public enum RequestResult {
        case success
        case fail
    }

    public static func request(target: MoyaProvider<FlexHire>.Target, success: @escaping SuccessCallback, error: @escaping ErrorCallback, userRequired: Bool = true) {
        if (!userRequired) || (UserManager.shared.getState != .failed) {
            API.shared.provider.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        if let text: String = try response.mapString() {
                            print(text)
                            if let dictionary: [String: Any] = try response.mapDictionary() {
                                print(response.statusCode)
                                if (response.statusCode == 200) || (response.statusCode == 201) {
                                    success(result, dictionary)
                                    return
                                } else {
                                    if let message: String = dictionary["message"] as? String {
                                        if message.contains("Signature") {
                                            UserManager.shared.invokeApiError()
                                        }
                                        error(result, message)
                                        return
                                    } else {
                                        error(result, "")
                                        return
                                    }
                                }
                            } else {
                                error(result, text)
                                return
                            }
                        } else {
                            error(result, "plaing")
                            return
                        }
                    } catch { }
                    error(result, "lol")
                    return
                case .failure:
                    error(result, "")
                    return
                @unknown default:
                    error(result, "")
                    return
                }
            }
        } else {
            error(Result<Moya.Response, MoyaError>.failure(.requestMapping("")), "user")
            UserManager.shared.invokeApiError()
        }
    }
}

extension API {
    func syncAll() { }
}
