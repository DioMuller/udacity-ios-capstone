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
        
        // If user already has a token, he's logged in.
        if UserData.token != nil {
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }


    @IBAction func login(_ sender: Any) {
        let oauthswift = OAuth2Swift(consumerKey: Constants.Authorization.clientId, consumerSecret: Constants.Authorization.clientId, authorizeUrl: Constants.Authorization.authorizationUrl, responseType: "token")
        
        self.oauthswift = oauthswift
        
        oauthswift.authorize(withCallbackURL: Constants.Authorization.redirectUrl, scope: Constants.Authorization.scope, state: "itch", success: { (credential, response, parameters) in
            // Success!
            UserData.token = parameters[Constants.Authorization.accessToken] as? String
            UserData.save()
            
            self.performSegue(withIdentifier: "login", sender: self)

        }, failure: { error in
            self.showMessage("Error", error.localizedDescription)
        })
        
    }
}

