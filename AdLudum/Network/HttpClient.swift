//
//  NetworkHelper.swift
//  AdLudum
//
//  Created by Diogo Muller on 17/11/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import OAuthSwift

class HttpClient {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Singleton Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static let _instance = HttpClient()
    static var instance : HttpClient { return _instance }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initializers
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private init() {
        let oauthswift = OAuth1Swift(consumerKey: Constants.Keys.apiKey,
                                     consumerSecret: Constants.Keys.apiSecretKey,
                                     requestTokenUrl: Constants.Authorization.requestTokenUrl,
                                     authorizeUrl: Constants.Authorization.authorizeUrl,
                                     accessTokenUrl: Constants.Authorization.accessTokenUrl)
        
        self.oauthswift = oauthswift
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var oauthswift : OAuth1Swift? = nil

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Base Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func authorize(success: @escaping SuccessHandler, failure: FailureHandler?) {
        oauthswift!.authorize(withCallbackURL: URL(string: Constants.Authorization.callbackUrl)!, success: success, failure: failure)
    }
    
    func execute<T>(request : HttpRequest, onResult : @escaping HttpResult<T> ) where T : Decodable {
        oauthswift?.client.request(request.url, method: request.method, success: { (response) in
            let data = response.data
            
            do {
                let returnValue = try JSONDecoder().decode(T.self, from: data)
                onResult(returnValue, nil)
            } catch {
                onResult(nil, CustomError("There was an error decoding the return value : \(error)."))
                return
            }

        }, failure: { (error) in
            onResult(nil, CustomError(error.localizedDescription))
        })
    }    
}
