//
//  HomeViewController.swift
//  AdLudum
//
//  Created by Diogo Muller on 05/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class HomeViewController : BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.instance.getTimeline{ (result, error) in
            if let error = error {
                self.showMessage("Error", error.localizedDescription)
                return
            } else {
                self.showMessage("Success!", "Got \(result?.statuses?.count ?? 0) tweets.")
            }
        }
    }
    
}
