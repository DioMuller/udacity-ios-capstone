//
//  GameDetailViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 27/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class GameDetailViewController : BaseViewController {
    var game : Game!
    
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cover = game.cover, let data = cover.data  {
            imageCover.image = UIImage(data: data)
            imageCover.isHidden = false
        } else {
            imageCover.isHidden = true
        }
        
        labelTitle.text = game.name
        labelDetail.text = game.summary
    }
}
