//
//  TemplateCollectionView.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 05/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class TemplateCollectionView: UIView {
    
    @IBOutlet var templateCollectionView: UICollectionView!
    @IBOutlet var containerView: UIView!
    
    var arrTemplates = ["Add a textual note","Add attachment with text","Add a pdf", "Add a web page","Add a handwritten note"]
    
    var showPDF : Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    func initialSetup() {
        Bundle.main.loadNibNamed("TemplateCollectionView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        templateCollectionView.register(UINib(nibName: "TemplateCell", bundle: nil), forCellWithReuseIdentifier: "templateCell")
    }
}

extension TemplateCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templateCell", for: indexPath) as! TemplateCell
        cell.lblTemplate.text = arrTemplates[indexPath.row]
        cell.templateType = TemplateType(rawValue: Int16(indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.templateCollectionView.frame.size.width/2 - 16
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let templateType = TemplateType(rawValue: Int16(indexPath.row))
        
        switch templateType {
        case .Text:
            showTextViewController()
        case .TextWithAttachment:
            showAttachmentAlertController()
        case .PDF:
            showPDF = true
            showWebPDFViewController()
        case .Webpage:
            showPDF = false
            showWebPDFViewController()
        case .HandwrittenText:
            showDrawViewController()
        default:
            print("Invalid template choosen")
        }
    }
    
    func showTextViewController() {
        let currentVC = self.findViewController()!
        currentVC.push(newVC: TextViewController.self)
    }
    
    func showAttachmentAlertController() {
        let currentVC = self.findViewController()!
        currentVC.push(newVC: AttachmentViewController.self)
//        let actionSheet = UIAlertController(title: "Add an attachment", message: "choose file type to add", preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (action) -> Void in
//            //            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Access photo gallery", style: .default, handler: { (action) -> Void in
//            //            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Add video", style: .default, handler: { (action) -> Void in
//            //            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
//
//        }))
//
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        let currentVC = self.findViewController()!
//        currentVC.present(actionSheet, animated: true, completion: nil)
    }
    
    func showWebPDFViewController() {
        let currentVC = self.findViewController()!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "WebPdfViewController") as! WebPdfViewController
        showVC.showPDF = showPDF
        currentVC.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func showDrawViewController() {
        let currentVC = self.findViewController()!
        currentVC.push(newVC: DrawViewController.self)
    }
}
