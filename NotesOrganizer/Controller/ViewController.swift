//
//  ViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 26/02/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GestureDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet var templateView: TemplateCollectionView!
    
    var menuView: SideBarView!
    var isLoadingFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMenuAndContents()
        DataController.shared.initStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if self.menuView.isOpen {
            self.menuView.isOpen = false
            dismissMenu()
        }
    }
    
    func loadMenuViewFromNib() -> UIView? {
        return Bundle.main.loadNibNamed("SideBarView", owner: nil, options: nil)?.first as? UIView
    }
    
    func loadMenuAndContents(){
        showMenu()
        menuView.gestureDelegate = self
        menuView.commonSetup()
        self.menuView.isOpen = false
        isLoadingFirstTime = false
    }
    
    func showMenu() {
        guard let menu = loadMenuViewFromNib() else {
            return
        }
        menuView = menu as? SideBarView
        menuView.frame = CGRect(x: 0, y: self.headerView.frame.size.height + 44.0, width: menu.frame.size.width, height: menu.frame.size.height)
        menuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if !isLoadingFirstTime {
            view.addSubview(menuView)
        }
        self.menuView.isOpen = true
    }
    
    func dismissMenu() {
        self.menuView.menuTableView.removeFromSuperview()
        self.menuView.backgroundView.removeFromSuperview()
        self.menuView.removeFromSuperview()
    }
    
    // MARK:- Gesture delegate methods
    
    func openMenu() {
        if !self.menuView.isOpen {
            self.menuView.isOpen = true
            showMenu()
        }
        
    }
    
    func closeMenu() {
        if self.menuView.isOpen {
            self.menuView.isOpen = false
            dismissMenu()
        }
    }
    
    // MARK:- IBAction methods
    
    @IBAction func openMenu(_ sender: UIButton) {
        if self.menuView.isOpen {
            self.menuView.isOpen = false
            dismissMenu()
        } else {
            self.menuView.isOpen = true
            showMenu()
            menuView.gestureDelegate = self
            menuView.commonSetup()
        }
    }
}

