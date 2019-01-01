//
//  ViewController.swift
//  Itch
//
//  Created by Diogo Muller on 28/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: BaseViewController {

    var oauthswift : OAuthSwift? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        showLoading("Logging In...")
        
        let oauthswift = OAuth2Swift(consumerKey: Constants.Authorization.clientId, consumerSecret: Constants.Authorization.clientId, authorizeUrl: Constants.Authorization.authorizationUrl, responseType: "token")
        
        self.oauthswift = oauthswift
        
        oauthswift.authorize(withCallbackURL: URL(string: Constants.Authorization.redirectUrl), scope: Constants.Authorization.scope, state: "itch", success: { (credential, response, parameters) in
            // Success!
            self.performSegue(withIdentifier: "login", sender: self)

        }, failure: { error in
            self.showMessage("Error", error.localizedDescription)
        })
        
    }
}

