//
//  UIView-Ext.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 05/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if image != nil {
            return image!
        }
        return UIImage()
    }
    
    func showAlertWith(message: String) {
        let alertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        let alertController = UIAlertController.init(title: "Alert !!", message: message, preferredStyle: .alert)
        alertController.addAction(alertAction)
        let currentVC = self.findViewController()!
        currentVC.present(alertController, animated: true, completion: nil)
    }
}
