//
//  Response.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 09/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import Moya
public extension Response {
    /// Maps data received from the signal into a Dictionary object.
    ///
    /// - parameter failsOnEmptyData: A Boolean value determining
    /// whether the mapping should fail if the data is empty.
    func mapDictionary() -> [String: Any] {
        do {
            if let dictionary = try self.mapJSON() as? [String: Any] {
                return dictionary
            } else {
                return [:]
            }
        } catch {
            return [:]
        }
    }
}
