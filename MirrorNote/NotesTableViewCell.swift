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
         
         //         if let content = note?.content {
         //            print("content = \(content)")
         //         } else {
         //            print("content = nil")
         //         }
         
         dateOfCreationLabel.text = DateFormatter.localizedString(from: newValue.dateOfCreation! as Date, dateStyle: .short, timeStyle: .none)
         
         
         //Перед началом логики нужно объявить основные переменные
         let noteContent = newValue.content!
         
         
         //Если в поисковике что-то написано, то продолжаем
         if theViewController.searchController.isActive && theViewController.searchBar.text != "" {
            
            //Если контент содержит текст searchBar'a, то продолжаем
            if noteContent.lowercased().contains(theViewController.searchBar.text!.lowercased()) {
               
               
               
               
               
            }
         }
            
         //Иначе, если есть вторая строчка, заносим ее в additional
         else {
            if noteContent.contains("\n") {
            
               
               print("Длина постфикса будет = \(noteContent.characters.count - noteContent.getPrefixWithFirstFoundSymbol("\n").characters.count)")
               additionalLabel.text = noteContent.getPostfixWithLength(noteContent.characters.count - noteContent.getPrefixWithFirstFoundSymbol("\n").characters.count - 1)
               
               //
               if additionalLabel.text == "" {
                  additionalLabel.text = "[No additional text]"
               }
               
            } else {
               additionalLabel.text = "[No additional text]"
            }
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
