//
//  ViewController.swift
//  AdLudum
//
//  Created by Diogo Muller on 02/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import OAuthSwift
import UIKit

class LoginViewController : BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {        
        TwitterClient.instance.authorize(success: {(credential, response, parameters) in
            UserData.token = parameters[Constants.UserData.token] as? String
            UserData.tokenSecret = parameters[Constants.UserData.tokenSecret] as? String
            UserData.userId = parameters[Constants.UserData.userId] as? String
            UserData.userName = parameters[Constants.UserData.userName] as? String
            
            UserData.save()
            
            self.performSegue(withIdentifier: "login", sender: self)
        }, failure: { error in
            self.showMessage("Error", "There was an error logging in to twitter.")
            print("Error: \(error.localizedDescription)")
        })

    }
    
}

