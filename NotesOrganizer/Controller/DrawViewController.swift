//
//  DrawViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 07/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

enum ColorType {
    case purple
    case indigo
    case blue
    case green
    case yellow
    case orange
    case red
    case black
}

extension ColorType: RawRepresentable {
    typealias RawValue = CGColor
    
    var rawValue: CGColor {
        switch self {
        case .purple:
            return UIColor.systemPurple.cgColor
        case .indigo:
            return UIColor.systemIndigo.cgColor
        case .blue:
            return UIColor.systemBlue.cgColor
        case .green:
            return UIColor.systemGreen.cgColor
        case .yellow:
            return UIColor.systemYellow.cgColor
        case .orange:
            return UIColor.systemOrange.cgColor
        case .red:
            return UIColor.systemRed.cgColor
        default:
            return UIColor.black.cgColor
        }
    }
    
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case UIColor.systemPurple.cgColor: self = .purple
        case UIColor.systemIndigo.cgColor: self = .indigo
        case UIColor.systemBlue.cgColor: self = .blue
        case UIColor.systemGreen.cgColor: self = .green
        case UIColor.systemYellow.cgColor: self = .yellow
        case UIColor.systemOrange.cgColor: self = .orange
        case UIColor.systemRed.cgColor: self = .red
        case UIColor.black.cgColor: self = .black
        default: return nil
        }
    }
}


class DrawViewController: UIViewController {
    
    var canvas = CanvasView()
    
    @IBOutlet var DrawContainerView: UIView!
    var nameOfScreenshot = ""
    
    var note : Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        if note == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        canvas.frame = DrawContainerView.frame
        canvas.backgroundColor = .white
    }
    
    @objc func addNote(){
        let screenshot = canvas.captureImage()
        nameOfScreenshot = UUID().uuidString
        DispatchQueue.global(qos: .background).async {
            do {
                //                let result = Utility.shared.addImage(image: screenshot, forName: self.nameOfScreenshot)
                let result = try DataController.shared.addImage(image: screenshot, forName: self.nameOfScreenshot, andTemplateType: TemplateType.HandwrittenText.rawValue)
                switch result
                {
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
            } catch {
                
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveNote() {
        let alertController = UIAlertController(title: "Alert !!", message: "Do you want to update ? The previous screenshot will be deleted", preferredStyle: .alert)
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let alertOk = UIAlertAction(title: "Okay", style: .default) { (okAction) in
            let screenshot = self.canvas.captureImage()
            DispatchQueue.global(qos: .background).async {
                do {
                    //                    let result = Utility.shared.updateImage(image: screenshot, forName: self.nameOfScreenshot)
                    let result = try DataController.shared.updateImage(image: screenshot, forNote: self.note!)
                    switch result
                    {
                    case .success(let message):
                        print(message)
                    case .failure(let error):
                        print(error)
                    case .none:
                        print("")
                    }
                } catch {
                    
                }
            }
        }
        
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        self.present(alertController, animated: true)
    }
    
    
    // MARK:- IBAction
    
    @IBAction func undoDraw(_ sender: UIButton) {
        canvas.undo()
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        canvas.clearAll()
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        
        let buttonTag = sender.tag
        switch buttonTag {
        case 11:
            canvas.setPenColour(color: ColorType.purple.rawValue)
        case 22:
            canvas.setPenColour(color: ColorType.indigo.rawValue)
        case 33:
            canvas.setPenColour(color: ColorType.blue.rawValue)
        case 44:
            canvas.setPenColour(color: ColorType.green.rawValue)
        case 55:
            canvas.setPenColour(color: ColorType.yellow.rawValue)
        case 66:
            canvas.setPenColour(color: ColorType.orange.rawValue)
        case 77:
            canvas.setPenColour(color: ColorType.red.rawValue)
        case 88:
            canvas.setPenColour(color: ColorType.black.rawValue)
        default:
            canvas.setPenColour(color: ColorType.black.rawValue)
        }
    }
    
    @IBAction func changePenWidth(_ sender: UISlider) {
        let width = sender.value
        canvas.setPenWidth(width: CGFloat(width))
    }
    
}
