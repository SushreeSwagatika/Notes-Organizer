//
//  AttachmentViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 05/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {
    
    var imagePicker: ImageVideoPicker!
    
    var chosenImage: UIImage?
    var chosenURL: URL?
    
    var note : Note? = nil
    var forEdit = false
    var txtViewDesc = ""
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var videoView: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtView.text = note?.title != nil ? note?.title! : "Add some description .."
        
        if note == nil {
            forEdit = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAttachment))
        } else {
            forEdit = true
            revampNavBar()
            
            print(note!)
            if note?.imageData == nil { // set video url
                let dateFormat = "yyyy-MM-dd HH:mm:ss"
                let filePathURL = Utility.shared.videoFilePath(forKey: Date().toString(dateFormat: dateFormat))
                if let videoData = note?.videoData {
                    do {
                        try videoData.write(to: filePathURL!)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                    print("videoData = \(videoData)")
                    DispatchQueue.global().async { [weak self] in
                        do {
                            if let data = try? Data(contentsOf: filePathURL!) {
                                print("data = \(data)")
                                self?.chosenURL = filePathURL
                                self!.setData()
                            }
                        } catch let err {
                            print("Saving file resulted in error: ", err)
                        }
                    }
                }
            } else if note?.videoData == nil { // set image
                let dateFormat = "yyyy-MM-dd HH:mm:ss"
                let filePathURL = Utility.shared.imageFilePath(forKey: Date().toString(dateFormat: dateFormat))!
                if let imageData = note?.imageData {
                    do  {
                        try imageData.write(to: filePathURL, options: .atomic)
                        print(filePathURL)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                    DispatchQueue.global().async { [weak self] in
                        if let data = try? Data(contentsOf: filePathURL) {
                            if let image = UIImage(data: data) {
                                self?.chosenImage = image
                            }
                        }
                    }
                    self.imageView.load(url: filePathURL)
                }
            }
            
            setData()
            self.txtViewDesc = self.note?.title! ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtView.text = note?.title != nil ? note?.title! : "Add some description .."
    }
    
    @objc func addAttachment() {
        self.imagePicker = ImageVideoPicker(presentationController: self, delegate: self)
        
        self.imagePicker.present(from: self.view)
        if let trimmedText = Utility.shared.trim(str: self.txtView.text), txtView.text != nil {
            note?.title = trimmedText
        }
    }
    
    func setData() {
        DispatchQueue.main.async {
            if self.chosenImage != nil && self.chosenURL == nil { // add image
                self.videoView.isHidden = true
                self.imageView.isHidden = false
                self.imageView.image = self.chosenImage
            } else if self.chosenURL != nil && self.chosenImage == nil { // add video
                self.imageView.isHidden = true
                self.videoView.isHidden = false
                self.videoView.url = self.chosenURL
                
                self.setupVideoView()
                self.videoView.player?.play()
            }
        }
    }
    
    func setupVideoView() {
        self.videoView.contentMode = .scaleAspectFill
        self.videoView.player?.isMuted = true
        self.videoView.repeat = .loop
    }
    
    func revampNavBar() {
        let saveNoteButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAttachment))
        navigationItem.rightBarButtonItems = [saveNoteButton, addNoteButton]
    }
    
    @objc func saveNote() {
        
        txtViewDesc = txtView.text
        let trimmedText = Utility.shared.trim(str: txtViewDesc)!
        
        if forEdit {
            let alertController = UIAlertController(title: "Alert !!", message: "Do you want to save ? The previous attachment will be deleted", preferredStyle: .alert)
            
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
                self.dismiss(animated: true, completion: nil)
            }
            let alertOk = UIAlertAction(title: "Okay", style: .default) { (okAction) in
                
                if trimmedText != "" && trimmedText != "Add some description .." {
                    self.note?.title = trimmedText
                    DispatchQueue.global(qos: .background).async {
                        do {
                            var result: Result<SuccessMessage, FailureError>?
                            if self.chosenImage != nil && self.chosenURL == nil { // add image
                                result = try DataController.shared.updateImage(image: self.chosenImage!, forNote: self.note!)
                                
                            } else if self.chosenURL != nil && self.chosenImage == nil { // add video
                                result = try DataController.shared.updateVideo(url: self.chosenURL!, forNote: self.note!)
                            }
                            switch result
                            {
                            case .success(let message):
                                print(message)
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            case .failure(let error):
                                print(error)
                            case .none:
                                print("")
                            }
                        } catch {
                            
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.showAlertWith(message: "Add some note description !!")
                    }
                }
            }
            
            alertController.addAction(alertOk)
            alertController.addAction(alertCancel)
            self.present(alertController, animated: true)
        }
        else {
            DispatchQueue.global(qos: .background).async {
                do {
                    var result: Result<SuccessMessage, FailureError>?
                    
                    if self.chosenImage != nil && self.chosenURL == nil { // add image
                        result = try DataController.shared.addImage(image: self.chosenImage!, forName: self.txtViewDesc, andTemplateType: TemplateType.TextWithAttachment.rawValue)
                    } else if self.chosenURL != nil && self.chosenImage == nil { // add video
                        result = try DataController.shared.addVideo(url: self.chosenURL!, forName: self.txtViewDesc, andTemplateType: TemplateType.TextWithAttachment.rawValue)
                    }
                    
                    switch result
                    {
                    case .success(let message):
                        print(message)
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    case .none:
                        print("")
                    }
                } catch {
                    
                }
            }
        }
    }
}

extension AttachmentViewController: ImageVideoPickerDelegate {
    
    func didSelect(image: UIImage?, url: URL?) {
        self.chosenImage = (image != nil) ? image : nil
        self.chosenURL = (url != nil) ? url : nil
        
        setData()
        
        revampNavBar()
    }
}

extension AttachmentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtView.text = note?.title != nil ? note?.title! : ""
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        txtViewDesc = txtView.text
    }
}

