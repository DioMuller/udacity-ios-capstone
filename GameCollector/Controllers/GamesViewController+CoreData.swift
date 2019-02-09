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
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
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
        if fetchedResultController == nil {
            fetchedResultController = createFetchedResultsController()
            fetchedResultController.delegate = self
        } else {
            fetchedResultController.fetchRequest.predicate = getPredicate()
        }
        
        do {
            try fetchedResultController.performFetch()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}
