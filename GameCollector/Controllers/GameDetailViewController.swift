//
//  GameDetailViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 27/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import TagListView
import UIKit

class GameDetailViewController : BaseViewController {
    
    var game : Game!
    
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var buttonCollection: UIBarButtonItem!
    @IBOutlet weak var buttonWishlist: UIBarButtonItem!
    @IBOutlet weak var listPlatforms: TagListView!
    @IBOutlet weak var listGenres: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let cover = game.cover, let data = cover.data  {
            imageCover.image = UIImage(data: data)
            imageCover.isHidden = false
        } else {
            imageCover.isHidden = true
        }
        
        labelTitle.text = game.name ?? "No Title"
        labelDetail.text = game.summary ?? "This game has no description."

        for item in (game.platforms?.allObjects ?? []) {
            if let platform = item as? Platform {
                listPlatforms.addTag(platform.name ?? "Unknown")
            }
        }
        
        for item in (game.genres?.allObjects ?? []) {
            if let genre = item as? Genre {
                listGenres.addTag(genre.name ?? "Unknown")
            }
        }
        
        setButtonStatus()
    }
    
    private func setButtonStatus() {
        buttonCollection.tintColor = game.favorited ? Constants.Colors.activeColor : Constants.Colors.inactiveColor
        buttonWishlist.tintColor = game.wishlisted ? Constants.Colors.activeColor : Constants.Colors.inactiveColor
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleCollection(_ sender: Any) {
        game.favorited = !game.favorited
        save()
        setButtonStatus()
    }
    
    @IBAction func toggleWishlist(_ sender: Any) {
        game.wishlisted = !game.wishlisted
        save()
        setButtonStatus()
    }
}
