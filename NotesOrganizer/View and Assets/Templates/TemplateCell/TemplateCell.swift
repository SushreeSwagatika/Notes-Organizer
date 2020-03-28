//
//  TemplateCell.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 05/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

enum TemplateType: Int16 {
    case Text = 0
    case TextWithAttachment
    case PDF
    case Webpage
    case HandwrittenText
}

@IBDesignable class TemplateCell: UICollectionViewCell {

    @IBOutlet var lblTemplate: UILabel!
    
    var templateType: TemplateType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true;
        self.contentView.clipsToBounds = true
    }

}
