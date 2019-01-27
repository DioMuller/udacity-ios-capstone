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

class GamesViewController: GameCollectionViewController {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var filterGenre : Int? = nil
    var filterPlatform : Int? = nil
    var loadingData : Bool = false
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var textSearch: UITextField!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UIViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItems(refresh: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let genresView = segue.destination as? GenresViewController {
            genresView.parentList = self
        } else if let platformsView = segue.destination as? PlatformsViewController {
            platformsView.parentList = self
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: GameCollectionViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func createFetchedResultsController() -> NSFetchedResultsController<Game> {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func updateItems(refresh : Bool) {
        if loadingData {
            return
        }
        
        loadingData = true
        // Do any additional setup after loading the view, typically from a nib.
        var filters : [String] = []
        
        let search = textSearch!.text
        
        if let genre = filterGenre {
            filters.append("genres = \(genre)")
        }
        
        if let platform = filterPlatform {
            filters.append("platforms = \(platform)")
        }
        
        IGDBClient.instance.getGames(limit: 50, offset: refresh ? 0 : itemCount, search: search!, filters: filters) { (result, error) in
            self.loadingData = false
            
            guard error == nil else {
                self.showMessage("Error", error!.localizedDescription)
                return
            }
            
            if refresh {
                self.clearCache()
            }
            
            let games = result ?? []
            
            for gameData in games {
                let _ = self.createOrUpdateGame(gameData)
            }
            
            PersistedData.save()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITableViewDelegate
    //////////////////////////////////////////////////////////////////////////////////////////////////    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = fetchedResultController.object(at: indexPath)
        var actions : [UIContextualAction] = []
        
        if !item.favorited {
            let favoriteAction = UIContextualAction(style: .normal, title: "Add to Collection") { (action, view, handler) in
                item.favorited = true
                PersistedData.save()
            }
            
            actions.append(favoriteAction)
        } else {
            let favoriteAction = UIContextualAction(style: .destructive, title: "Remove from Collection") { (action, view, handler) in
                item.favorited = false
                PersistedData.save()
            }
            
            actions.append(favoriteAction)
        }
    
        if !item.wishlisted {
            let wishlistAction = UIContextualAction(style: .normal, title: "Add to Wishlist") { (action, view, handler) in
                item.wishlisted = true
                PersistedData.save()
            }
            
            actions.append(wishlistAction)
        } else {
            let wishlistAction = UIContextualAction(style: .destructive, title: "Remove from Wishlist") { (action, view, handler) in
                item.favorited = false
                PersistedData.save()
            }
            
            actions.append(wishlistAction)
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Game Creation/Update Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func createGame(_ game : GameModel) -> Game {
        let newGame = Game(context: dataController.viewContext)
        
        newGame.id = Int32(game.id)
        newGame.name = game.name
        newGame.summary = game.summary
        newGame.rating = game.rating ?? 0
        
        newGame.cover = game.cover != nil ? createOrFindCover(game.cover!) : nil
        
        newGame.genres = NSSet(array: PersistedData.getGenres(game))
        newGame.platforms = NSSet(array: PersistedData.getPlatforms(game))
        
        return newGame
    }
    
    public func createOrUpdateGame(_ game : GameModel) -> Game {
        if let existing = findGame(id: game.id) {
            existing.name = game.name
            existing.summary = game.summary
            existing.rating = game.rating ?? 0
            
            existing.genres = NSSet(array: PersistedData.getGenres(game))
            existing.platforms = NSSet(array: PersistedData.getPlatforms(game))
            
            return existing
        } else {
            return createGame(game)
        }
    }
    
    private func findGame(id : Int) -> Game? {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "id = %d", Int32(id))
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            return result.first
        }
        
        return nil
    }
    
    private func clearCache() {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Game.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false

        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "wishlisted = 0 && favorited == 0")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try dataController.viewContext.execute(deleteRequest)
        } catch {
            print("Error deleting all unused items.")
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

