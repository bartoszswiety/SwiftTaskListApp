//
//  API.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import Moya
import CoreData

public class API
{
    public static var shared: API = API()
    public let provider = MoyaProvider<FlexHire>()

    public enum RequestResult
    {
        case success
        case fail
    }
}
