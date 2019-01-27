//
//  GameCollectionViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 26/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class GameCollectionViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var tableView: UITableView!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var fetchedResultController : NSFetchedResultsController<Game>!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var itemCount : Int {
        var count = 0

        for section in fetchedResultController.sections ?? [] {
            count += section.numberOfObjects
        }
        
        return count
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UIViewController
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        fetchedResultController = createFetchedResultsController()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

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
    // MARK: Abstract Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func createFetchedResultsController() -> NSFetchedResultsController<Game> {
        preconditionFailure("This method must be overriden.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITableViewDataSource
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as? GameCell
        
        cell?.setGame(game)
        
        return cell!
    }
}
