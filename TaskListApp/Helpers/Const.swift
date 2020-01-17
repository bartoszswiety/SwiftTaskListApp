//
//  Const.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

struct Const {
    public var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        return dateFormatter
    }
}
