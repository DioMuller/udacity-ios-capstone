//
//  ViewController.swift
//  AdLudum
//
//  Created by Diogo Muller on 02/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import OAuthSwift
import UIKit

class LoginViewController : UIViewController {

    var oauthswift : OAuthSwift? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {
        let oauthswift = OAuth1Swift(consumerKey: Constants.Authorization.consumerKey,
                                     consumerSecret: Constants.Authorization.consumerKey,
                                     requestTokenUrl: Constants.Authorization.requestTokenUrl,
                                     authorizeUrl: Constants.Authorization.authorizeUrl,
                                     accessTokenUrl: Constants.Authorization.accessTokenUrl)
        
        self.oauthswift = oauthswift
        
        oauthswift.authorize(withCallbackURL: URL(string: Constants.Authorization.redirectUrl)!, success: { (credential, response, parameters) in
            // Success!
            print("Success!")
        }, failure: { error in
            print("Error: \(error.localizedDescription)")
        })

    }
    
}

