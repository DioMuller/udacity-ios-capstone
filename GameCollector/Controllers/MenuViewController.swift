//
//  MenuViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 03/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UITableViewController {
    
    var detailViewController : GamesViewController? = nil
    
    override func viewDidLoad() {
        detailViewController = self.splitViewController?.viewControllers.last as? GamesViewController
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        detailViewController?.clearSearch()

        switch cell?.tag {
        case 0: // All Games
            detailViewController?.changeState(.listing)
            break
        case 1: // Search by Platform
            detailViewController?.changeState(.filtering, showPlatforms: true)
            break
        case 2: // Search by Genre
            detailViewController?.changeState(.filtering, showGenres: true)
            break
        case 3: // My Collection
            detailViewController?.changeState(.favorites)
            break
        case 4: // Wishlist
            detailViewController?.changeState(.wishlist)
            break
        default: // Wtf?
            detailViewController?.changeState(.listing)
        }
        
        splitViewController?.showDetailViewController(detailViewController!, sender: self)
    }
}
