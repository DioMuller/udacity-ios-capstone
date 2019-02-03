//
//  GamesViewController+NSFetchedResultsControllerDelegate.swift
//  GameCollector
//
//  Created by Diogo Muller on 03/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import CoreData
import Foundation

extension GamesViewController : NSFetchedResultsControllerDelegate {

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: NSFetchedResultsControllerDelegate methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            
        default:
            break
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Helper methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func updateData() {
        fetchedResultController = createFetchedResultsController()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Cover Creation Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func findCover(id : Int) -> Cover? {
        let fetchRequest : NSFetchRequest<Cover> = Cover.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "id = %d", Int32(id))
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            return result.first
        }
        
        return nil
    }
    
    public func createOrFindCover(_ id : Int) -> Cover {
        if let existing = findCover(id: id) {
            return existing
        }
        
        let newItem = Cover(context: dataController.viewContext)
        newItem.id = Int32(id)
        return newItem
    }
}
