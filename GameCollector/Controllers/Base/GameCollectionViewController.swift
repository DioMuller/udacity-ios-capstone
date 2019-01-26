//
//  GameCollectionViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 26/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class GameCollectionViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var games: [Game] = []
    
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
}
