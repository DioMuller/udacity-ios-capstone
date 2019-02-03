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
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
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
        
        let favoriteAction = UIContextualAction(style: item.favorited ? .destructive : .normal,
                                            title: item.favorited ? "Remove from Collection" : "Add to Collection",
                                            handler: { (action, view, handler) in
            item.favorited = !item.favorited
            PersistedData.save()
        })
        
        let wishlistAction = UIContextualAction(style: item.wishlisted ? .destructive : .normal,
                                            title: item.wishlisted ? "Remove from Wishlist" : "Add to Wishlist",
                                            handler: { (action, view, handler) in
            item.wishlisted = !item.wishlisted
            PersistedData.save()
        })
        
        return UISwipeActionsConfiguration(actions: [favoriteAction, wishlistAction])
    }

}
