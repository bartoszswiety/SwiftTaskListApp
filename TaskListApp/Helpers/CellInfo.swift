//
//  Info.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 23/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

struct InfoCellData {
    var name: String
    var value: String
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

struct ButtonCellData {
    var title = ""

    init(title: String) {
        self.title = title
    }
}
