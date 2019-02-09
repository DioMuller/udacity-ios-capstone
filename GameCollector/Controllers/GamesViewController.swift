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
    var currentState : GamesViewState = .listing
    var shouldShowGenres : Bool = false
    var shouldShowPlatforms : Bool = false
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !PersistedData.importDone {
            self.showLoading("Loading data...")
            PersistedData.initialize { (success) in
                self.hideLoading()
                self.updateItems(refresh: true)
            }
        } else {
            if !self.checkFilters() {
                self.updateItems(refresh: true)
            }
        }
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
        let fetchRequest : NSFetchRequest<Game> = createFetchRequest()

        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func createFetchRequest() -> NSFetchRequest<Game> {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = getPredicate()
        
        return fetchRequest
    }
    
    internal func getPredicate() -> NSPredicate? {
        var filter : String
        
        switch currentState {
        case .listing:
            filter = "listed = 1"
            break
        case .favorites:
            filter = "favorited = 1"
            break
        case .wishlist:
            filter = "wishlisted = 1"
            break
        case .filtering:
            filter = "listed = 1"
            break
        }
        
        let predicate = NSPredicate(format: filter)
        return predicate
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Helper Functions
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func checkFilters() -> Bool {
        if shouldShowGenres {
            shouldShowGenres = false
            showGenres()
            return true
        } else if shouldShowPlatforms {
            shouldShowPlatforms = false
            showPlatforms()
            return true
        }
        
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBActions
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func search(_ sender: Any) {
        if (currentState == .filtering || currentState == .listing) {
            changeState(.filtering, filterGenre: filterGenre, filterPlatform: filterPlatform)
            updateItems(refresh: true)
        }
    }
}

