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

    var oauthswift : OAuthSwift? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {
        let oauthswift = OAuth1Swift(consumerKey: Constants.Keys.apiKey,
                                     consumerSecret: Constants.Keys.apiSecretKey,
                                     requestTokenUrl: Constants.Authorization.requestTokenUrl,
                                     authorizeUrl: Constants.Authorization.authorizeUrl,
                                     accessTokenUrl: Constants.Authorization.accessTokenUrl)
        
        self.oauthswift = oauthswift
        
        oauthswift.authorize(withCallbackURL: URL(string: Constants.Authorization.callbackUrl)!, success: { (credential, response, parameters) in
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

