//
//  TwitterClient.swift
//  AdLudum
//
//  Created by Diogo Muller on 06/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import OAuthSwift

class TwitterClient {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Singleton Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static let _instance = TwitterClient()
    static var instance : TwitterClient { return _instance }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private let oauthswift : OAuth1Swift
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initializers
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private init() {
        oauthswift = OAuth1Swift(consumerKey: Constants.Keys.apiKey,
                                     consumerSecret: Constants.Keys.apiSecretKey,
                                     requestTokenUrl: Constants.Authorization.requestTokenUrl,
                                     authorizeUrl: Constants.Authorization.authorizeUrl,
                                     accessTokenUrl: Constants.Authorization.accessTokenUrl)
        
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Auth Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func authorize(success: @escaping OAuthSwift.TokenSuccessHandler, failure: OAuthSwift.FailureHandler?) {
        oauthswift.authorize(withCallbackURL: URL(string: Constants.Authorization.callbackUrl)!, success: success, failure: failure)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Call Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func getTimeline(onResult: @escaping HttpResult<SearchResponse>) {
        let _ = oauthswift.client.get(getUrl(Constants.Methods.search), parameters: [
                Constants.Parameters.query : Constants.Values.query,
                Constants.Parameters.count : Constants.Values.count,
                Constants.Parameters.resultType : Constants.Values.recent,
                Constants.Parameters.searchType : Constants.Values.follows
            ], success: { (response) in
                let data = response.data
                let result : SearchResponse? = self.getResult(data: response.data)
                onResult(result, nil)
                print("Success!")
            }, failure: { (error) in
                print("Error!")
            })
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func getUrl(_ method : String) -> String {
        return "\(Constants.Api.baseUrl)/\(method)"
    }
    
    func getResult<T>(data : Data) -> T? where T : Decodable {
        do {
            let returnValue = try JSONDecoder().decode(T.self, from: data)
            return returnValue
        } catch {
            return nil
        }
    }
}
