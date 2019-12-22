//
//  Organized.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 21/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation

public class Organizable: NSManagedObject {
    // MARK: Needed Preporties

    @NSManaged public var id: Int64
    @NSManaged public var title: String?

    @NSManaged public var created_at: Date?
    @NSManaged public var updated_at: Date?
}
