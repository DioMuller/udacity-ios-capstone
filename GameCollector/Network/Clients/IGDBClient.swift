//
//  IGDBClient.swift
//  GameCollector
//
//  Created by Diogo Muller on 15/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class IGDBClient {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Singleton Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static let _instance = IGDBClient()
    static var instance : IGDBClient { return _instance }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public func getGames(limit : Int, offset : Int, onResult: @escaping HttpResult<[Game]>) {
        var body = IGDBRequest()
        body.limit = limit
        body.offset = offset
        
        let headers = [
            Constants.Headers.userKey : Constants.Keys.apiKey,
            Constants.Headers.accept : Constants.Values.acceptType
        ]
        
        let request = HttpRequest(
            scheme: Constants.Api.scheme,
            host : Constants.Api.host,
            path : Constants.Api.path,
            withExtension : Constants.Methods.games,
            method : .get,
            parameters : nil,
            headers : headers,
            body : body.getContent()
        )
        
        HttpClient.execute(request: request, onResult: onResult)
    }
    
    public func getPlatforms(limit : Int, offset : Int, onResult: @escaping HttpResult<[Platform]>) {
        var body = IGDBRequest()
        body.limit = limit
        body.offset = offset
        
        let headers = [
            Constants.Headers.userKey : Constants.Keys.apiKey,
            Constants.Headers.accept : Constants.Values.acceptType
        ]
        
        let request = HttpRequest(
            scheme: Constants.Api.scheme,
            host : Constants.Api.host,
            path : Constants.Api.path,
            withExtension : Constants.Methods.platforms,
            method : .get,
            parameters : nil,
            headers : headers,
            body : body.getContent()
        )
        
        HttpClient.execute(request: request, onResult: onResult)
    }
}
