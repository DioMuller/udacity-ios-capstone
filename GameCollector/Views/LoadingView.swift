//
//  LoadingView.swift
//  GameCollector
//
//  Created by Diogo Muller on 02/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var labelStatus: UILabel!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func setStatus(_ status : String) {
        labelStatus.text = status
    }
}