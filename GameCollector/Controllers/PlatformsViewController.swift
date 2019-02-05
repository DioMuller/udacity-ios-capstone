//
//  PlatformsViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 20/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class PlatformsViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var platforms : [Platform] = []
    var parentList : GamesViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        platforms = PersistedData.platforms.map({ (key, value) -> Platform in
            return value
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platforms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let platform = platforms[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "platformCell")
        
        cell?.textLabel!.text = platform.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let platform = platforms[(indexPath as NSIndexPath).row]
        
        parentList.filterPlatform = Int(platform.id)
        
        dismiss(animated: true, completion: nil)
    }
}
