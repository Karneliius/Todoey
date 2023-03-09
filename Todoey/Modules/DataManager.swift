//
//  DataManager.swift
//  Todoey
//
//  Created by Anelya Kabyltayeva on 08.03.2023.
//

import Foundation
import UIKit

protocol DataManagerDelegate {
    
    func didUpdateModelList(with models: [TodoeyItem])
    func didFailWithError(error: Error)
    
}

struct DataManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: DataManagerDelegate?
    
    static var shared = DataManager()
    
    func fetchItems(with text:String = "" ) {
        do {
            let request =  TodoeyItem.fetchRequest()
            if text != "" {
                let predicate = NSPredicate(format: "name CONTAINS %@", text)
                request.predicate = predicate
            }
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            
            let models = try context.fetch(request)
            delegate?.didUpdateModelList(with: models)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func createItem(with name: String) {
        let newItem = TodoeyItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        do {
            try context.save()
            let request = TodoeyItem.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(TodoeyItem.fetchRequest())
            delegate?.didUpdateModelList(with: models)
        } catch {
            print ("Following error appeared: ", error)
        }
    }
    
    func deleteItem(item: TodoeyItem) {
        context.delete(item)
        do {
            try context.save()
            let request = TodoeyItem.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(TodoeyItem.fetchRequest())
            delegate?.didUpdateModelList(with: models)            
        } catch {
            print ("Following error appeared: ", error)
        }
    }
    
    func updateItem(item: TodoeyItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            let request = TodoeyItem.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(TodoeyItem.fetchRequest())
            delegate?.didUpdateModelList(with: models)
        } catch {
            print ("Following error appeared: ", error)
        }
    }
}
