//
//  Syncable.swift
//  TaskListApp
//
//  Created by Bartosz Swiety on 27/12/2019.
//  Copyright © 2019 Bartosz Swiety. All rights reserved.
//

import CoreData
import Foundation

@objc(Syncable)
public class Syncable: NSManagedObject {
    /// Reflects only backend ID; -1 if not synced.
    @NSManaged public var id: Int64

    /// Warning - Flexhire backend TodoItem name is reflected by title!
    @NSManaged public var title: String

    /// Reflects local creation date - but is upadted to backend creation after first sync.
    @NSManaged public var created_at: Date

    /// Reflects local creation date - but is updated to backend when synced;
    @NSManaged public var updated_at: Date

    /// Reflects only synced date - Why we added it? To know if we have done any change after last sync.
    /// -optimistic: equal to update_at
    @NSManaged public var synced_at: Date?

    override public func setValue(_ value: Any?, forKey key: String) {

        super.setValue(value, forKey: key)

        guard(key != "updated_at")
            else {
                // No need to add trigget to update_at
                return
        }

        setValue(NSDate(), forKey: "updated_at")
    }
}

extension Syncable {
    @objc func set(dictionary: [String: Any]) {
        if let id: Int64 = dictionary["id"] as? Int64 {
            self.id = id
        }

        if let title: String = dictionary["title"] as? String {
            self.title = title
        }

        if let created_at: Date = DateFormatter.date(string: dictionary["created_at"] as! String) {
            self.created_at = created_at
        }

        if let updated_at: Date = DateFormatter.date(string: dictionary["updated_at"] as! String) {
            self.updated_at = updated_at
        }
    }
}

extension Syncable {
//    MARK: - Helpers

    /// Checks if Todo has been synced basing on `id`
    public var isSynced: Bool {
        return id != -1
    }

    /// We can update syncTime and updateTime - becasue they contain the same version.
    public func updateSyncTime() {
        setValue(NSDate(), forKey: "created_at")
    }
}

extension Syncable {
    // MARK: - Edit Methods

    /// Changes a title of the local Todo
    /// -Tries to synces  with Cloud
    func rename(title: String) {
        self.title = title
        setValue(title, forKey: "title")
        TodoManager.shared.syncTitle(item: self)
    }
}
