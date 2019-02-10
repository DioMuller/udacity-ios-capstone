//
//  GamesViewController+TableView.swift
//  GameCollector
//
//  Created by Diogo Muller on 03/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

extension GamesViewController : UITableViewDelegate, UITableViewDataSource {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITableViewDataSource
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = fetchedResultController.sections?[section].numberOfObjects ?? 0
        
        tableView.backgroundView = (value == 0) ? placeholderNoGames : nil
        
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as? GameCell
        
        cell?.setGame(game)
        
        return cell!
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UITableViewDelegate
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGame", sender: self)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = fetchedResultController.object(at: indexPath)
        
        let favoriteAction = UIContextualAction(style: .normal,
                                            title: item.favorited ? "Remove from Collection" : "Add to Collection",
                                            handler: { (action, view, success) in
            item.favorited = !item.favorited
            PersistedData.save(useBackgroundContext: false)
            success(true)
        })
        
        favoriteAction.backgroundColor = item.favorited ? Constants.Colors.removeColor : Constants.Colors.activeColor
        
        let wishlistAction = UIContextualAction(style: .normal,
                                            title: item.wishlisted ? "Remove from Wishlist" : "Add to Wishlist",
                                            handler: { (action, view, success) in
            item.wishlisted = !item.wishlisted
            PersistedData.save(useBackgroundContext: false)
            success(true)
        })
        
        wishlistAction.backgroundColor = item.wishlisted ? Constants.Colors.removeColor : Constants.Colors.activeColor
        
        return UISwipeActionsConfiguration(actions: [wishlistAction, favoriteAction])
    }

}
