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

class GameDetailViewController : BaseViewController, TagListViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    var game : Game!
    var genres : [String:Int] = [:]
    var platforms : [String:Int] = [:]
    var listView : GamesViewController!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var buttonCollection: UIBarButtonItem!
    @IBOutlet weak var buttonWishlist: UIBarButtonItem!
    @IBOutlet weak var listPlatforms: TagListView!
    @IBOutlet weak var listGenres: TagListView!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: UIViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
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
            if let platform = item as? Platform, let name = platform.name {
                platforms[name] = Int(platform.id)
                listPlatforms.addTag(name)
            }
        }
        
        for item in (game.genres?.allObjects ?? []) {
            if let genre = item as? Genre, let name = genre.name {
                genres[name] = Int(genre.id)
                listGenres.addTag(name)
            }
        }
        
        setButtonStatus()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Helper Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func setButtonStatus() {
        buttonCollection.tintColor = game.favorited ? Constants.Colors.activeColor : Constants.Colors.inactiveColor
        buttonWishlist.tintColor = game.wishlisted ? Constants.Colors.activeColor : Constants.Colors.inactiveColor
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: TagListViewDelegate Functions
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
        if sender == listPlatforms {
            listView.changeState(.filtering, filterPlatform: platforms[title] ?? 0)
            dismiss(animated: true, completion: nil)
        } else if sender == listGenres {
            listView.changeState(.filtering, filterGenre: genres[title] ?? 0)
            dismiss(animated: true, completion: nil)
        }
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBActions
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleCollection(_ sender: Any) {
        game.favorited = !game.favorited
        save(useBackgroundContext: false)
        setButtonStatus()
    }
    
    @IBAction func toggleWishlist(_ sender: Any) {
        game.wishlisted = !game.wishlisted
        save(useBackgroundContext: false)
        setButtonStatus()
    }
}
