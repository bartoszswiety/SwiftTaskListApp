//
//  TaskModel.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 06/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation
import Moya

@objc(Todo)
/// Todo is a core class of  the App.
/// Todo is containted in CoreData and supports NSManagedObjects class.
///
/// Todo class is a container class for TodoItem objects.
/// Todo class has one required preporerty `title` which is needed for saving into CoreData.
/// Todo class which is not saved and not synced has `id` = -1

public class Todo: Syncable, Decodable {
//    MARK: - Initalizers



    /// Creates an instance in persistant Controller.
    /// - Parameter title: <#title description#>
    convenience init(title: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.contex)
        setValue(title, forKey: "title")
        setValue(NSDate(), forKey: "created_at")
        setValue(NSDate(), forKey: "updated_at")
        setValue(-1, forKey: "id")
    }


    //MARK: - JSON
    enum CodingKeys: String, CodingKey {
        case title
        case summary = "description"
        case link
        case image = "imageURL"
        case createdDate = "date"
    }

    /// Decodes in Temporary Controller.
    /// - Parameter decoder: <#decoder description#>
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Todo", in: CoreDataStack.contex)!, insertInto: CoreDataStack.tempContex)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)

    }
}

extension Todo {
//    MARK: -  Preporties

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var created_by: Int64
    @NSManaged private var items: NSSet?

}

extension Todo {
//     MARK: - Core Data Methods

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: TodoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: TodoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
}

extension Todo {
    // MARK: - Item Managment

    /// Creates local unnamed `TodoItem` and adds to its container.
    /// new `TodoItem` is not synced with Cloud
    func createItem() -> TodoItem {
        let item = TodoItem(title: "unnamed", parent: self)
        addToItems(item)
        return item
    }

    /// Sorts `items` by `created_at` date DESC
    /// - returns: `[TodoItem]` form `items`
    public var itemsSorted: [TodoItem] {
        return (items?.allObjects as! [TodoItem]).sorted { (item1, item2) -> Bool in
            item1.created_at > item2.created_at
        }
    }

    /// Filters sorted `items` marked as `done`
    /// - returns: `[TodoItem]` marked as`done`
    public var itemsDone: [TodoItem] {
        return itemsSorted.filter { (item) -> Bool in
            item.done
        }
    }

    /// Removes the `TodoItem` from its container
    /// Change is saved&&synced with Cloud!
    ///
    /// - parameter index: Index of `TodoItem` in containe
    func removeFormItems(index: Int) {
        removeFromItems(itemsSorted[index])
        TodoManager.shared.save()
        // TODO: Sync Remove TodoItem
    }
}

extension Todo {
//    MARK: - Syncing CloudData with Local.

    /// Translates `dictionary` to `Todo` preporties.
    /// Change is not saved in CoreData!.
    /// - Parameter dictionary: with preporties names -
    /// ["id", "created_by","title","created-at","updated_at").

    override func set(dictionary: [String: Any]) {
        if let created_by: Int64 = dictionary["created_by"] as? Int64 {
            self.created_by = created_by
        }
        super.set(dictionary: dictionary)
    }
}
