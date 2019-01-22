//
//  WishlistViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

import UIKit

class WishlistViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var wishlist : [Game] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wishlist = PersistedData.getWishlist()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genre = wishlist[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistGameCell")
        
        cell?.textLabel!.text = genre.name
        
        return cell!
    }
    
}
