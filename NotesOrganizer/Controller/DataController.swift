//
//  DataController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 18/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class DataController {
    
    static var shared = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "NotesOrganizer")
    
    var context : NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func initStack() {
        self.persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            //            description.shouldAddStoreAsynchronously = true
            print("store loaded")
        }
    }
    
    func fetchAllNotes() throws -> [Note] {
        let notes = try self.context.fetch(Note.fetchRequest() as NSFetchRequest<Note>)
        return notes
    }
    
    func fetchNotes(withNoteType noteType:Int) throws -> [Note]? {
        let request = NSFetchRequest<Note>(entityName: "Note")
        switch noteType {
        case NoteSection.Favorites.rawValue:
            request.predicate = NSPredicate(format: "isFavorite == %i",noteType)
        default:
            print("")
        }
        let notes = try self.context.fetch(request)
        return notes
    }
    
    func addNote(withTitle title: String, andSubtitle subtitle: String, andTemplateType templateType:Int16) throws -> Result<SuccessMessage, FailureError>? {
        let note = Note(context: self.context)
        note.title = title
        note.subtitle = subtitle
        note.isFavorite = false
        note.createdAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
        note.noteId = UUID().uuidString
        note.imageData = nil
        note.type = templateType
        
        do  {
            self.context.insert(note)
            if context.hasChanges {
                try self.context.save()
                return .success(.success200)
            }
        } catch let err {
            print("Saving file resulted in error: ", err)
            return .failure(.coreDataSaveError)
        }
        return nil
    }
    
    func addImage(image:UIImage, forName name:String, andTemplateType templateType:Int16) throws -> Result<SuccessMessage, FailureError>? {
        if let pngRepresentation = image.pngData() {
            let note = Note(context: self.context)
            note.title = name
            note.subtitle = "Note with Image"
            note.isFavorite = false
            note.createdAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
            note.noteId = UUID().uuidString
            note.imageData = pngRepresentation
            note.type = templateType
            
            do  {
                self.context.insert(note)
                if context.hasChanges {
                    try self.context.save()
                    return .success(.success200)
                }
            } catch let err {
                print("Saving file resulted in error: ", err)
                return .failure(.coreDataSaveError)
            }
        }
        return nil
    }
    
    func updateImage(image: UIImage, forNote note: Note) throws -> Result<SuccessMessage, FailureError>? {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.predicate = NSPredicate(format: "noteId == %@",note.noteId!)
        
        let note = try self.context.fetch(request).first!
        
        if let pngRepresentation = image.pngData() {
            note.imageData = pngRepresentation
            note.updatedAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        do  {
            if context.hasChanges {
                try self.context.save()
                return .success(.success200)
            }
        } catch let err {
            print("Saving file resulted in error: ", err)
            return .failure(.coreDataSaveError)
        }
        return  nil
    }
    
    func addVideo(url:URL, forName name:String, andTemplateType templateType:Int16) throws -> Result<SuccessMessage, FailureError>? {
        do {
            let videoData = try Data(contentsOf: url)
            let note = Note(context: self.context)
            note.title = name
            note.subtitle = "Note with Video"
            note.isFavorite = false
            note.createdAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
            note.noteId = UUID().uuidString
            note.videoData = videoData
            note.type = templateType
            
            do  {
                self.context.insert(note)
                if context.hasChanges {
                    try self.context.save()
                    return .success(.success200)
                }
            } catch let err {
                print("Saving file resulted in error: ", err)
                return .failure(.coreDataSaveError)
            }
            
        } catch {
            print("Unable to load data: \(error)")
            return .failure(.attachmentSaveError)
        }
        return nil
    }
    
    func updateVideo(url:URL, forNote note: Note) throws -> Result<SuccessMessage, FailureError>? {
        do {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.predicate = NSPredicate(format: "noteId == %@",note.noteId!)
            
            let note = try self.context.fetch(request).first!
            
            let videoData = try Data(contentsOf: url)
            note.videoData = videoData
            note.updatedAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
            
            do  {
                if context.hasChanges {
                    try self.context.save()
                    return .success(.success200)
                }
            } catch let err {
                print("Saving file resulted in error: ", err)
                return .failure(.coreDataSaveError)
            }
        } catch {
            print("Unable to load data: \(error)")
            return .failure(.attachmentSaveError)
        }
        return  nil
    }
    
    func updateNote(withNoteId id:String , updatedNote:Note) throws -> Result<SuccessMessage, FailureError>? {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.predicate = NSPredicate(format: "noteId == %@",id)
        
        let note = try self.context.fetch(request).first!
        
        note.title = updatedNote.title
        note.subtitle = updatedNote.subtitle
        note.isFavorite = updatedNote.isFavorite
        note.updatedAt = Utility.shared.getCurrentDate(withFormat: "yyyy-MM-dd HH:mm:ss")
        
        do  {
            if context.hasChanges {
                try self.context.save()
                return .success(.success200)
            }
        } catch let err {
            print("Saving file resulted in error: ", err)
            return .failure(.coreDataSaveError)
        }
        return  nil
    }
    
    func deleteNote(withNoteId id:String) throws  -> Result<SuccessMessage, FailureError>? {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.predicate = NSPredicate(format: "noteId == %@",id)
        
        let note = try self.context.fetch(request).first!
        
        do  {
            self.context.delete(note)
            try self.context.save()
            return .success(.success200)
        } catch let err {
            print("Saving file resulted in error: ", err)
            return .failure(.coreDataSaveError)
        }
    }
    
}
