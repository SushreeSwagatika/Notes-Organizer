//
//  Note+CoreDataProperties.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 18/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var noteId: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var type: Int16
    @NSManaged public var imageData: Data?
    @NSManaged public var videoData: Data?
}
