//
//  UIViewcontroller-Ext.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 06/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func present(newVC: UIViewController.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "\(newVC)")
        showVC.modalPresentationStyle = .fullScreen
        self.present(showVC, animated: true, completion: nil)
    }
    
    func push(newVC: UIViewController.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "\(newVC)")
        self.navigationController?.pushViewController(showVC, animated: true)
    }
}
