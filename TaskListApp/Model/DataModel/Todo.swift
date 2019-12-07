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

    convenience init(title: String)
    {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        self.setValue(title, forKey: "title")
    }
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


