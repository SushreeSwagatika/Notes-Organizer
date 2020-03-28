//
//  SideBarView.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 28/02/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

enum NoteSection: Int {
    case AllNotes = 0
    case Favorites
}

protocol GestureDelegate: class {
    func openMenu()
    func closeMenu()
}

class SideBarView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    
    var isOpen = false
    
    weak var gestureDelegate : GestureDelegate?
    
    var arrNotes = ["All Notes", "Favorites"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        commonSetup()
    }
    
    // MARK: -
    
    func commonSetup() {
        tableSetup()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGestureRecognizer.direction = .left
        self.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    
    func tableSetup() {
        self.menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.menuTableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK:- objc methods
    
    @objc func handleSwipe(_ swipeGesture:UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case .left:
            gestureDelegate?.closeMenu()
        default:
            print("Default case")
        }
    }
    
    @objc func handleTapGesture(_ tapGestureRecognizer:UITapGestureRecognizer) {
        gestureDelegate?.closeMenu()
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        //        var snapshot : DragView?
        //        var sourceIndexPath : IndexPath?
        
        let gestureState = longPressGestureRecognizer.state
        
        if gestureState == .began {
            self.menuTableView.isEditing = true
            
            self.menuTableView.reloadData()
        }
    }
    //        switch gestureState {
    //        case .began:
    //            self.menuTableView.isEditing = true
    //            self.menuTableView.reloadData()
    //        case .ended:
    //            self.menuTableView.isEditing = false
    //            self.menuTableView.reloadData()
    //        default:
    //
    //        }
    //        if gestureState == .began {
    //
    //            let location = longPressGestureRecognizer.location(in: self.menuTableView)
    //            if let tappedIndexPath = self.menuTableView.indexPathForRow(at: location) {
    //
    //                switch gestureState {
    //                case .began:
    //                    sourceIndexPath = tappedIndexPath;
    //
    //                    let cell = self.menuTableView.cellForRow(at: tappedIndexPath)!
    //
    //                    // Take a snapshot of the selected row using helper method.
    //                    let snapshotView = self.customSnapshotFromView(inputView: cell)
    //
    //                    snapshot = DragView()
    //                    snapshot?.imageView = snapshotView
    //                    snapshot?.frame = snapshotView.frame
    //
    //
    //
    //                    // Add the snapshot as subview, centered at cell's center...
    //                    var center = cell.center
    //                    snapshot!.center = center
    //                    snapshot!.alpha = 0.0
    //                    self.menuTableView.addSubview(snapshot!)
    //
    //                    UIView.animate(withDuration: 0.25, animations: {
    //                        // Offset for gesture location.
    //                        center.y = location.y
    //                        snapshot!.center = center
    //                        snapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
    //                        snapshot!.alpha = 0.98
    //
    //                        // Fade out.
    //                        cell.alpha = 0.0;
    //                    }) { (done) in
    //                        cell.isHidden = true
    //                    }
    //                case .changed:
    //                    var center = snapshot!.center
    //                    center.y = location.y
    //                    snapshot!.center = center
    //
    //                    // Is destination valid and is it different from source?
    //                    if tappedIndexPath != sourceIndexPath {
    //                        self.arrNotes.swapAt(tappedIndexPath.row, sourceIndexPath!.row)
    //                        self.menuTableView.moveRow(at: sourceIndexPath!, to: tappedIndexPath)
    //                        sourceIndexPath = tappedIndexPath
    //                    }
    //                case .ended:
    //                    print("gesture ended")
    //                default:
    //                    //Clean up.
    //                    let cell = self.menuTableView.cellForRow(at: tappedIndexPath)!
    //                    cell.isHidden = false
    //                    cell.alpha = 0.0
    //                    UIView.animate(withDuration: 0.25, animations: {
    //                        snapshot!.center = cell.center
    //                        snapshot!.transform = CGAffineTransform.identity
    //                        snapshot!.alpha = 0.0
    //
    //                        // Undo fade out.
    //                        cell.alpha = 1.0
    //                    }) { (done) in
    //                        sourceIndexPath = nil
    //                        snapshot!.removeFromSuperview()
    //                        snapshot = nil
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    //    func customSnapshotFromView(inputView: UIView) -> UIImageView {
    //
    //        // Make an image from the input view.
    //        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    //        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
    //        let image = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        // Create an image view.
    //        let snapshot = UIImageView(image: image)
    //        snapshot.layer.masksToBounds = false
    //        snapshot.layer.cornerRadius = 0.0
    //        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
    //        snapshot.layer.shadowRadius = 5.0
    //        snapshot.layer.shadowOpacity = 0.4
    //
    //        return snapshot
    //    }
}

extension SideBarView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableView DataSource and Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = self.arrNotes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentVC = self.findViewController()!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        
        let rowType = NoteSection(rawValue: indexPath.row)
        switch rowType {
        case .AllNotes:
            showVC.noteSectionType = .AllNotes
        case .Favorites:
            showVC.noteSectionType = .Favorites
        default:
            print("Invalid selection")
        }
        currentVC.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.arrNotes[sourceIndexPath.row]
        self.arrNotes.remove(at: sourceIndexPath.row)
        self.arrNotes.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

