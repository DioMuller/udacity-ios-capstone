//
//  TwitterClient.swift
//  AdLudum
//
//  Created by Diogo Muller on 06/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class TwitterClient {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Singleton Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static let _instance = TwitterClient()
    static var instance : TwitterClient { return _instance }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private let httpClient : HttpClient
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initializers
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private init() {
        httpClient = HttpClient.instance
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func getTimeline(onResult: @escaping HttpResult<SearchResponse>) {
        let request = HttpRequest(
            scheme: Constants.Api.apiScheme,
            host: Constants.Api.apiHost,
            path: Constants.Api.apiPath,
            withExtension: Constants.Methods.timeline,
            method: .GET,
            parameters: [:],
            headers: [:],
            body: nil)
        
        /*
        Constants.Parameters.query : Constants.Values.query as AnyObject,
        Constants.Parameters.count : Constants.Values.count as AnyObject,
        Constants.Parameters.resultType : Constants.Values.recent as AnyObject,
        Constants.Parameters.searchType : Constants.Values.follows as AnyObject,
         */
        
        httpClient.execute(request: request, onResult: onResult)
    }
}
