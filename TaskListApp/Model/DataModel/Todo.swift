//
//  TaskModel.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}
extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var createdBy: Int64
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var test: Float

}
