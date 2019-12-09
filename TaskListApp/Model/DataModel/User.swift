//
//  User.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

public class User: Codable
{
    public var access_key: String = "elo"
    {
        didSet
        {
            save()
        }
    }
    public var email: String = ""
    public var login: String = ""
}


