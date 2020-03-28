//
//  Date-Ext.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 21/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import Foundation

extension Date {
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
