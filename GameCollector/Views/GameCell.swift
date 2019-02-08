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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentGame : Game?
    
    func setGame(_ game : Game) {
        currentGame = game
        
        imageFavorited.isHidden = !game.favorited
        imageWishlisted.isHidden = !game.wishlisted
        
        labelTitle.text = game.name
        
        if let platformCount = game.platforms?.count, platformCount > 1 {
            labelPlatforms.text = "\(platformCount) Platforms"
        } else {
            labelPlatforms.text = (game.platforms?.allObjects.first as? Platform)?.name ?? "No Platforms"
        }
        
        if let genreCount = game.genres?.count, genreCount > 1 {
            labelGenres.text = "\(genreCount) Genres"
        } else {
            labelGenres.text = (game.genres?.allObjects.first as? Genre)?.name ?? "No Genres"
        }
        
        self.imageCover.image = UIImage(named: "Placeholder")
        self.activityIndicator.isHidden = false
        
        if let coverData = game.cover {
            if let data = coverData.data {
                self.activityIndicator.isHidden = true
                self.imageCover.image = UIImage(data: data)
            } else {
                PersistedData.downloadImage(coverData) { (image, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        if let image = image, image.game == self.currentGame, let data = image.data {
                            self.imageCover.image = UIImage(data: data)
                        }
                    }
                }
            }
            
        } else {
            self.activityIndicator.isHidden = (game.cover == nil)
        }
    }
}
