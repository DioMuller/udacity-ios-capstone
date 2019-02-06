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
        PersistedData.initialize { (success) in
            self.performSegue(withIdentifier: "goToMain", sender: self)
        }
    }
}
