//
//  HomeViewController.swift
//  AdLudum
//
//  Created by Diogo Muller on 05/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tweets : [Tweet] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tweetCell", for: indexPath) as! TweetCollectionViewCell
        let tweet = tweets[indexPath.row]
        
        // TODO: Async, outside the class.
        if let imageUrl = tweet.entities?.media?[0].mediaUrl {
            if let imageData = try? Data(contentsOf: URL(string: imageUrl)! ) {
                cell.imageView.image = UIImage(data: imageData)
            }
        }
        
        if let avatarUrl = tweet.user?.profileImage {
            if let imageData = try? Data(contentsOf: URL(string: avatarUrl)! ) {
                cell.imageUserIcon.image = UIImage(data: imageData)
            }
        }
        
        cell.labelUsername.text = tweet.user?.name ?? "Unknown User"
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.instance.getTimeline{ (result, error) in
            if let error = error {
                self.showMessage("Error", error.localizedDescription)
                return
            } else {
                self.tweets = result?.statuses ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
