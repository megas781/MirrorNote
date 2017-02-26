//
//  NotesTableViewCell.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
   
   var note: Note!
   
   @IBOutlet weak var firstLineLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var additionalLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      //Потом допили логику
      
      firstLineLabel.text = note.content!
      dateLabel.text = DateFormatter.localizedString(from: note.dateOfCreation! as Date, dateStyle: .short, timeStyle: .none)
      additionalLabel.text = "Потом добавим логику additional label'a"
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
