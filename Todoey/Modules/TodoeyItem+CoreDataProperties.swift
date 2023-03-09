//
//  TodoeyItem+CoreDataProperties.swift
//  
//
//  Created by Anelya Kabyltayeva on 09.03.2023.
//
//

import Foundation
import CoreData


extension TodoeyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoeyItem> {
        return NSFetchRequest<TodoeyItem>(entityName: "TodoeyItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var section: TodoeySection?

}
