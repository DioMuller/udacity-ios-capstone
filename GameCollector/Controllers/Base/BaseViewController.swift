//
//  BaseViewController.swift
//  GameCollector
//
//  Created by Diogo Muller on 21/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Components
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private var viewLoading : LoadingView? = nil
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // Core Data Controller.
    internal var dataController : DataController = DataController.getInstanceOf(key: "GameCollector")
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: ViewController Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        // Create Loading View
        viewLoading = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?.first as! LoadingView?
        self.view.addSubview(viewLoading!)
        viewLoading?.translatesAutoresizingMaskIntoConstraints = false
        
        // Set Constraints
        let topConstraint = NSLayoutConstraint(item: viewLoading!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: viewLoading!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: viewLoading!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: viewLoading!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        // Setup Data Controller.
        dataController = DataController.getInstanceOf(key: "GameCollector")
        
        
        // Deactivate it for now
        hideLoading()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    func showMessage(_ title: String, _ message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func navigateToUrl(_ address : String) -> Bool {
        let url = URL(string: address)!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        
        return false
    }
    
    func showLoading(_ message : String) {
        setLoadingVisible(true, message)
    }
    
    func hideLoading() {
        setLoadingVisible(false)
    }
    
    func setEnabled(_ enabled : Bool ){
        
    }
    
    func save(useBackgroundContext : Bool = false) {
        let context = useBackgroundContext ? dataController.backgroundContext : dataController.viewContext
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func cleanString(_ text : String) -> String {
        return text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func setLoadingVisible(_ show : Bool, _ message : String? = nil) {
        DispatchQueue.main.async {
            self.setEnabled(!show)
            self.viewLoading?.isHidden = !show
            self.viewLoading?.labelStatus.text = message ?? ""
        }
    }
}
