//
//  NotesTableViewCell.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
   
   var theViewController : NotesTableViewController!
   
   var note: Note! {
      willSet {
         //Потом допили логику
         
         //Название заметки
         firstLineLabel.text = newValue.content!
         

         dateOfCreationLabel.text = DateFormatter.localizedString(from: newValue.dateOfCreation! as Date, dateStyle: .short, timeStyle: .none)
         
         
         //Logic of additional text
         if theViewController.searchController.isActive && theViewController.searchBar.text != "" {
            
            additionalLabel.text = "ищешь, я знаю"
            
         } else {
            additionalLabel.text = "неа, не ищешь"
         }
         
         
         
         
         
      }
   }
   
   @IBOutlet weak var firstLineLabel: UILabel!
   
   @IBOutlet weak var dateOfCreationLabel: UILabel!
   @IBOutlet weak var additionalLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
