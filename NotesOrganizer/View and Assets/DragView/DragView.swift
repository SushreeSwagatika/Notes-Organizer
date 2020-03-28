//
//  DragView.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 29/02/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class DragView: UIView {
    
    // Starting center position
    var initialCenter: CGPoint?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
//        // create an NSData object from myView
//        let archive = NSKeyedArchiver.archivedData(withRootObject: myView)
//
//        // create a clone by unarchiving the NSData
//        let myViewCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
        imageView = UIImageView()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        addGestureRecognizer(longPress)
    }
    
//    func duplicate(forControlEvents controlEvents: [UIControl.Event]) -> UIButton? {
//
//        // Attempt to duplicate button by archiving and unarchiving the original UIButton
//        let archivedButton = NSKeyedArchiver.archivedData(withRootObject: self)
//        guard let buttonDuplicate = NSKeyedUnarchiver.unarchiveObject(with: archivedButton) as? UIButton else { return nil }
//
//        // Copy targets and associated actions
//        self.allTargets.forEach { target in
//
//            controlEvents.forEach { controlEvent in
//
//                self.actions(forTarget: target, forControlEvent: controlEvent)?.forEach { action in
//                    buttonDuplicate.addTarget(target, action: Selector(action), for: controlEvent)
//                }
//            }
//        }
//
//        return buttonDuplicate
//    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        
    }
    
    // Handle longPress action
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let view = gesture.view else {
                return
            }
            initialCenter = gesture.location(in: view.superview)
        }
        else if gesture.state == .changed {
            guard let originalCenter = initialCenter else {
                return
            }
            
            guard let view = gesture.view else {
                return
            }
            
            let point = gesture.location(in: view.superview)
            
            // Calculate new center position
            var newCenter = view.center;
            newCenter.x += point.x - originalCenter.x;
            newCenter.y += point.y - originalCenter.y;
            
            // Update view center
            view.center = newCenter
        }
        else if gesture.state == .ended {
            self.imageView = nil
            self.removeFromSuperview()
        }
    }
    
}
