//
//  GenreListController.swift
//  GameCollector
//
//  Created by Diogo Muller on 20/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class GenresViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var genres : [Genre] = []
    var parentList : GamesViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var placeholderNoGenres: UILabel!
    
    override func viewDidLoad() {
        genres = PersistedData.genres.map({ (key, value) -> Genre in
            return value
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = genres.count
        
        tableView.backgroundView = (value == 0) ? placeholderNoGenres : nil

        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genre = genres[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell")
        
        cell?.textLabel!.text = genre.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = genres[(indexPath as NSIndexPath).row]
        
        parentList.changeState(.filtering, filterGenre: Int(genre.id))
        
        navigationController?.popViewController(animated: true)
    }
}
