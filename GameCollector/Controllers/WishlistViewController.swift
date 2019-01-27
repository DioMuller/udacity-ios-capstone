//
//  WishlistViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class WishlistViewController: GameCollectionViewController {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: GameCollectionViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func createFetchedResultsController() -> NSFetchedResultsController<Game> {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "wishlisted == 1")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "notebooks")
    }
}
