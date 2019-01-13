//
//  DataController.swift
//  VirtualTourist
//
//  Created by Diogo Muller on 18/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private let persistentContainer : NSPersistentContainer
    private let backgroundContextInternal : NSManagedObjectContext
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext : NSManagedObjectContext {
        return backgroundContextInternal
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Constructor
    //////////////////////////////////////////////////////////////////////////////////////////////////
    internal init(modelName : String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContextInternal = persistentContainer.newBackgroundContext()

        configureContexts()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func load(completion : (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores(completionHandler: { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            if Constants.Parameters.autoSaveEnabled {
                self.autoSaveViewContext(interval: Constants.Parameters.autoSaveTime)
            }
            completion?()
        })
    }

}
