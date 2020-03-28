//
//  TextViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 05/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var note : Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
            textView.text = ""
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
            textView.text = note?.subtitle
        }
        
    }
    
    @objc func addNote(){
        if let trimmedText = Utility.shared.trim(str: textView.text) {
            if trimmedText != "" {
                let name = "TXT_" + UUID().uuidString + ".txt"
                
                DispatchQueue.global(qos: .background).async {
                    
                    do {
                        //                    let result = Utility.shared.saveNote(str: trimmedText, forName: name)
                        let result = try DataController.shared.addNote(withTitle: name, andSubtitle: trimmedText, andTemplateType: TemplateType.Text.rawValue)
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
            else {
                self.view.showAlertWith(message: "Add some note !!")
            }
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveNote(){
        if let trimmedText = Utility.shared.trim(str: textView.text) {
            if trimmedText != "" {
                let currentNote = note!
                currentNote.subtitle = trimmedText
                do {
                    let result = try DataController.shared.updateNote(withNoteId: currentNote.noteId!, updatedNote: currentNote)
                    switch result{
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
            else {
                self.view.showAlertWith(message: "Add some note !!")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
