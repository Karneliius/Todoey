//
//  TodoeySection+CoreDataProperties.swift
//  
//
//  Created by Anelya Kabyltayeva on 09.03.2023.
//
//

import Foundation
import CoreData


extension TodoeySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoeySection> {
        return NSFetchRequest<TodoeySection>(entityName: "TodoeySection")
    }

    @NSManaged public var name: String?
    @NSManaged public var items: TodoeyItem?

}
