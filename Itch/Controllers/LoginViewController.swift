//
//  ViewController.swift
//  Itch
//
//  Created by Diogo Muller on 28/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: self)
    }
}

