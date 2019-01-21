//
//  NetworkHelper.swift
//  GameCollector
//
//  Created by Diogo Muller on 17/11/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation

class HttpClient : NSObject {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Base Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    static func execute<T>(request : HttpRequest, onResult : @escaping HttpResult<T> ) where T : Decodable {
        let url = request.url
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.method.rawValue
        
        if request.headers != nil {
            for (key, value) in request.headers! {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = request.body {
            print(body)
            urlRequest.httpBody = body.data(using: .utf8, allowLossyConversion: false)
        }
        
        let task = createTask(urlRequest, onResult: onResult)
        
        task.resume()
    }
    
    static private func createTask<T>(_ request : URLRequest, onResult : @escaping HttpResult<T> ) -> URLSessionDataTask where T : Decodable {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                onResult(nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                onResult(nil, CustomError("Your request returned an invalid, unknown status code!"))
                return
            }
            
            guard statusCode >= 200 && statusCode <= 299 else {
                onResult(nil, CustomError("Your request returned an error status code: \(statusCode)"))
                return
            }
            
            
            guard let data = data else {
                onResult(nil, CustomError("Request Data was Empty."))
                return
            }
            
            do {
                let returnValue = try JSONDecoder().decode(T.self, from: data)
                onResult(returnValue, nil)
            } catch {
                onResult(nil, CustomError("There was an error decoding the return value : \(error)."))
                return
            }
        }
        
        return task
    }
}
