//
//  UserData.swift
//  AdLudum
//
//  Created by Diogo Muller on 01/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class UserData {
    static var token : String? {
        get {return UserDefaults.standard.string(forKey: Constants.UserData.token)}
        set {UserDefaults.standard.set(newValue, forKey: Constants.UserData.token)}
    }
    
    static var tokenSecret : String? {
        get {return UserDefaults.standard.string(forKey: Constants.UserData.tokenSecret)}
        set {UserDefaults.standard.set(newValue, forKey: Constants.UserData.tokenSecret)}
    }
    
    static var userId : String? {
        get {return UserDefaults.standard.string(forKey: Constants.UserData.userId)}
        set {UserDefaults.standard.set(newValue, forKey: Constants.UserData.userId)}
    }
    
    static var userName : String? {
        get {return UserDefaults.standard.string(forKey: Constants.UserData.userName)}
        set {UserDefaults.standard.set(newValue, forKey: Constants.UserData.userName)}
    }
    
    static func save() {
        UserDefaults.standard.synchronize()
    }
}
