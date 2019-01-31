//
//  GameDetailViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 27/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class GameDetailViewController : BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var game : Game!
    
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var buttonCollection: UIBarButtonItem!
    @IBOutlet weak var buttonWishlist: UIBarButtonItem!
    
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
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return game.genres?.count ?? 0
        } else if section == 1{
            return game.platforms?.count ?? 0
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionCell

        if indexPath.section == 0 {
            if let item = game.genres?.allObjects[indexPath.row] as? Genre {
                cell.labelText.text = item.name
            }
        } else if indexPath.section == 1 {
            if let item = game.platforms?.allObjects[indexPath.row] as? Platform {
                cell.labelText.text = item.name
            }
        } else {
            cell.labelText.text = "?"
        }
        
        return cell
    }
    
    // UICollectionViewDelegate
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 25)
    }
}
