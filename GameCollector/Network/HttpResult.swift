//
//  HttpResult.swift
//  GameCollector
//
//  Created by Diogo Muller on 18/11/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation

typealias HttpResult<T> = (_ result : T?, _ error : Error? ) -> Void where T : Decodable
