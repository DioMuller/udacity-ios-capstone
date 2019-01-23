//
//  GameCell.swift
//  GameCollector
//
//  Created by Diogo Muller on 23/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class GameCell : UITableViewCell {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageFavorited: UIImageView!
    @IBOutlet weak var imageWishlisted: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPlatforms: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    
    
    func setGame(_ game : Game) {
        imageFavorited.isHidden = !game.favorited
        imageWishlisted.isHidden = !game.wishlisted
        
        labelTitle.text = game.name
        
        if let platformCount = game.platforms?.count, platformCount > 1 {
            labelPlatforms.text = "\(platformCount) Platforms"
        } else {
            labelPlatforms.text = (game.platforms?.allObjects.first as? Platform)?.name ?? "No Platforms"
        }
        
        if let genreCount = game.genres?.count, genreCount > 1 {
            labelPlatforms.text = "\(genreCount) Genres"
        } else {
            labelGenres.text = (game.genres?.allObjects.first as? Genre)?.name ?? "No Genres"
        }
    }
}
