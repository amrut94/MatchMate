//
//  CoreDataManager.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import CoreData
import Foundation

// Main data manager to handle the todo items
class CoreDataManager: NSObject, ObservableObject {
    static let shared = CoreDataManager()
    
    // Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "MatchMateModel")
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
