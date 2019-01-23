//
//  GamesViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import UIKit

enum GameFilterType {
    case none, genre, platform
}

class GamesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var games : [Game] = []
    
    var filterGenre : Int? = nil
    var filterPlatform : Int? = nil
    var loadingData : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearch: UITextField!
    
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
        
        IGDBClient.instance.getGames(limit: 50, offset: refresh ? 0 : games.count, search: search!, filters: filters) { (result, error) in
            self.loadingData = false
            
            guard error == nil else {
                self.showMessage("Error", error!.localizedDescription)
                return
            }
            
            let games = result ?? []
            
            self.games = []
            
            for gameData in games {
                let game = PersistedData.createOrUpdateGame(gameData)
                self.games.append(game)
            }
            
            PersistedData.save()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITableViewDataSource
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as? GameCell

        cell?.setGame(game)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = games[indexPath.row]
        var actions : [UIContextualAction] = []
        
        if !item.favorited {
            let favoriteAction = UIContextualAction(style: .normal, title: "Add to Collection") { (action, view, handler) in
                item.favorited = true
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
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

