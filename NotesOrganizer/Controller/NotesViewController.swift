//
//  NotesViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 18/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    var noteSectionType : NoteSection?
    
    var notes : [Note] = []
    var showPDF = true
    
    @IBOutlet var tblNotes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch noteSectionType {
        case .AllNotes:
            fetchAllNotes()
            self.navigationItem.title = "All Notes"
        case .Favorites:
            favoriteNotes()
            self.navigationItem.title = "Favorites"
        default:
            print("")
        }
        
        
    }
    
    func tableSetup() {
        self.tblNotes.register(UITableViewCell.self, forCellReuseIdentifier: "noteCell")
    }
    
    func fetchAllNotes() {
        DispatchQueue.global().async {
            do {
                self.notes = try DataController.shared.fetchAllNotes()
                
                DispatchQueue.main.async {
                    self.tblNotes.reloadData()
                }
            } catch {
                
            }
        }
    }
    
    func favoriteNotes() {
        
        DispatchQueue.global().async {
            do {
                self.notes = try DataController.shared.fetchNotes(withNoteType: NoteSection.Favorites.rawValue)!
                
                DispatchQueue.main.async {
                    self.tblNotes.reloadData()
                }
            } catch {
                
            }
        }
    }
    
    func reloadTable() {
        switch noteSectionType {
        case .AllNotes:
            fetchAllNotes()
        case .Favorites:
            favoriteNotes()
        default:
            print("")
        }
        DispatchQueue.main.async {
            self.tblNotes.reloadData()
        }
    }
    
}

extension NotesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "noteCell")
        
        if let currentNote = notes[indexPath.row] as Note? {
            cell.textLabel?.text = currentNote.title
            cell.detailTextLabel?.text = currentNote.subtitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentNote = notes[indexPath.row] as Note? {
//            print(currentNote)
            
            let templateTypeRawValue = TemplateType(rawValue: Int16(currentNote.type))
            
            switch templateTypeRawValue {
            case .Text:
                showTextViewController(withNote: currentNote)
            case .TextWithAttachment:
                showAttachmentAlertController(withNote: currentNote)
            case .PDF:
                showPDF = true
                showWebPDFViewController(withNote: currentNote)
            case .Webpage:
                showPDF = false
                showWebPDFViewController(withNote: currentNote)
            case .HandwrittenText:
                showDrawViewController(withNote: currentNote)
            default:
                print("Invalid template choosen")
            }
        }
    }
    
    func showTextViewController(withNote note: Note) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "TextViewController") as! TextViewController
        showVC.note = note
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func showAttachmentAlertController(withNote note: Note) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "AttachmentViewController") as! AttachmentViewController
        showVC.note = note
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func showWebPDFViewController(withNote note: Note) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "WebPdfViewController") as! WebPdfViewController
        showVC.showPDF = showPDF
        showVC.note = note
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func showDrawViewController(withNote note: Note) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showVC = storyboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
        showVC.note = note
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") { (action, view, handler) in
            do {
                let currentNote = self.notes[indexPath.row]
                currentNote.isFavorite = true
                let result = try DataController.shared.updateNote(withNoteId: currentNote.noteId!, updatedNote: currentNote)
                switch result{
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
                
                self.reloadTable()
            } catch {
                
            }
        }
        
        let removeFavouriteAction = UIContextualAction(style: .normal, title: "Remove") { (action, view, handler) in
            do {
                let currentNote = self.notes[indexPath.row]
                currentNote.isFavorite = false
                let result = try DataController.shared.updateNote(withNoteId: currentNote.noteId!, updatedNote: currentNote)
                switch result{
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
                
                self.reloadTable()
            } catch {
                
            }
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            do {
                let currentNote = self.notes[indexPath.row]
                let result = try DataController.shared.deleteNote(withNoteId: currentNote.noteId!)
                switch result{
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
                
                self.reloadTable()
            } catch {
                
            }
        }
        
        var contextualActions : [UIContextualAction] = []
        switch noteSectionType {
        case .AllNotes:
            contextualActions = [favouriteAction , deleteAction]
        case .Favorites:
            contextualActions = [removeFavouriteAction , deleteAction]
        default:
            print("")
        }
        
        let configuration = UISwipeActionsConfiguration(actions: contextualActions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
