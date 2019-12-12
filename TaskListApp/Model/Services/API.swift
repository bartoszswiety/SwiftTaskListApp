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
    public static var shared: API = API()
    public let provider = MoyaProvider<FlexHire>()
}

extension API
{
    public typealias SuccessCallback = (_ result: Result<Moya.Response, MoyaError>, _ dictionary: [String: Any]) -> Void
    public typealias ErrorCallback = (_ result: Result<Moya.Response, MoyaError>, _ message: String) -> Void


    public enum RequestResult
    {
        case success
        case fail
    }

    public static func request(target: MoyaProvider<FlexHire>.Target, success: @escaping SuccessCallback, error: @escaping ErrorCallback)
    {
        API.shared.provider.request(target) { result in
            switch result
            {
            case let .success(response):
                do
                {
                    if let text: String = try response.mapString()
                    {
                        if let dictionary: [String: Any] = try response.mapDictionary()
                        {
                            if(response.statusCode == 200)
                            {
                                success(result, dictionary)
                            }
                            else
                            {
                                if let message: String = dictionary["message"] as! String
                                {

                                    if(message.contains("Signature"))
                                    {
                                        NotificationCenter.default.post(name: .userError, object: nil)
                                    }
                                    error(result, message)
                                }
                                else
                                {
                                    error(result, "")
                                }
                            }
                        }
                        else
                        {
                            error(result, text)
                        }
                    }
                    else
                    {
                        error(result, "plaing")
                    }
                }
                catch
                {
                }
                error(result, "lol")
            case .failure(_):
                error(result, "")
                return
            @unknown default:
                error(result, "")
                return
            }
        }
    }
}

extension API
{
    func syncAll()
    {

    }
}


extension Notification.Name {
    static var userError: Notification.Name {
        return .init(rawValue: "APIUser.error") }
}
