//
//  InitializerViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 06/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class InitializerViewController : BaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        self.showLoading("Loading data...")
        PersistedData.initialize { (success) in
            self.save()
            
            self.hideLoading()
            self.performSegue(withIdentifier: "goToMain", sender: self)
        }
    }
}
