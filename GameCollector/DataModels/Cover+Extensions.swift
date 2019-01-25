//
//  Cover+Extensions.swift
//  GameCollector
//
//  Created by Diogo Muller on 25/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

extension Cover {
    public var imageUrl : String? {
        if let imgId = imageId {
            return "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imgId).jpg"
        } else {
            return nil
        }
    }
}
