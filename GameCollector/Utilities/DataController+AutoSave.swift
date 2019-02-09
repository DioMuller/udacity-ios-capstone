//
//  DataController+AutoSave.swift
//  VirtualTourist
//
//  Created by Diogo Muller on 18/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation

extension DataController {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func autoSaveViewContext( interval : TimeInterval ) {
        
        guard interval > 0 else {
            print("Cannot set negative autosave interval")
            return
        }
        
        if context.hasChanges {
            print("Autosaving...")
            try? context.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
