//
//  HttpResult.swift
//  AdLudum
//
//  Created by Diogo Muller on 18/11/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import OAuthSwift

typealias HttpResult<T> = (_ result : T?, _ error : Error? ) -> Void where T : Decodable
typealias SuccessHandler = (_ credential: OAuthSwiftCredential, _ response: OAuthSwiftResponse?, _ parameters: [String: Any]) -> Void
typealias FailureHandler = (_ error: OAuthSwiftError) -> Void
