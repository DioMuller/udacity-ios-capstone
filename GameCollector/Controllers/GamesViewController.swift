//
//  GamesViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import CoreData
import UIKit

enum GameFilterType {
    case none, genre, platform
}

class GamesViewController: BaseViewController {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var filterGenre : Int? = nil
    var filterPlatform : Int? = nil
    var loadingData : Bool = false
    var fetchedResultController : NSFetchedResultsController<Game>!

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackSearch: UIStackView!
    
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
    // MARK: UIViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad(){
        super.viewDidLoad()
        
        fetchedResultController = createFetchedResultsController()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        updateItems(refresh: true)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detail = segue.destination as? GameDetailViewController, let row = tableView.indexPathForSelectedRow {
            detail.game = fetchedResultController.object(at: row)
        } else if let genresView = segue.destination as? GenresViewController {
            genresView.parentList = self
        } else if let platformsView = segue.destination as? PlatformsViewController {
            platformsView.parentList = self
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: GameCollectionViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func createFetchedResultsController() -> NSFetchedResultsController<Game> {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "cached == 1")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate

        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "notebooks")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBActions
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func showFilters(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Filter Type", preferredStyle: .actionSheet)
        
        let genreAction = UIAlertAction(title: "Genre", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "showGenres", sender: self)
        })
        
        let platformAction = UIAlertAction(title: "Platform", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "showPlatforms", sender: self)
        })
        
        let noneAction = UIAlertAction(title: "None", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.filterPlatform = nil
            self.filterGenre = nil
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            // Cancel Action.
        })
        
        optionMenu.addAction(genreAction)
        optionMenu.addAction(platformAction)
        optionMenu.addAction(noneAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func search(_ sender: Any) {
        updateItems(refresh: true)
    }
}

