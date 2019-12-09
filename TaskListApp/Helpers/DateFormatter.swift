//
//  DateFormatter.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func date(string: String) -> Date? {
        let formatter = DateFormatter()
        let text = string.split(separator: ".")[0]
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: String(text))
    }
}
