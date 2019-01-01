//
//  UserData.swift
//  Itch
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
    
    static func save() {
        UserDefaults.standard.synchronize()
    }
}
