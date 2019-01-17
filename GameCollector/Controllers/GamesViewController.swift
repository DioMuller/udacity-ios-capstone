//
//  GamesViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import UIKit

class GamesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var games : [GameModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        IGDBClient.instance.getGames(limit: 50, offset: 0) { (result, error) in
            guard error == nil else {
                self.showMessage("Error", error!.localizedDescription)
                return
            }
            
            self.games = result ?? []
            self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell")

        cell?.textLabel!.text = game.name
        
        return cell!

    }


}

