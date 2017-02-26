//
//  NotesTableViewCell.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

   @IBOutlet weak var firstLineLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var additionalLabel: UILabel!
   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
