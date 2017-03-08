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
            
            let result = theViewController.searchBar.text!
            var content = note.content!
            var textToShow : String = ""
            
            var lengthOfPostfix = 0
            
            //Сначала найдем длину префикса контента, содержащего результат
            findLengthOfPrefixContainingResult: for i in 1...content.characters.count {
               if content.getPrefixWithLength(i).lowercased().contains(result.lowercased()) {
                  //Здесь вычисляем длину
                  lengthOfPostfix = content.characters.count - (i - result.characters.count)
                  
                  break findLengthOfPrefixContainingResult
               }
            }
            
            //Здесь у нас есть длина постфикса содержащего result
            //Нужно найти первый проблелв префиксе content, а если его нет, то выводить всю строку, а если не умещается, то просто выводить постфикс с размером lengthOfPostfix
            
            if content.getPrefixWithLength(content.characters.count - lengthOfPostfix).contains(" ") {
               //Мы знаем, что префикс контента содержит пробел, значит свободно извлекаем по первому пробелу, и находим новую длину постфикса
               
               lengthOfPostfix += content.getPrefixWithLength(content.characters.count - lengthOfPostfix).getPostfixWithFirstFoundSymbol(" ").characters.count
               
               print("конечный постфикс = \(content.getPostfixWithLength(lengthOfPostfix))")
               
               additionalLabel.text = content.getPostfixWithLength(lengthOfPostfix)
               
            } else {
               //Если все вмещается, то добавляй все, а если нет, то ставь 3 точки и начинай с result, т.е. с lengthOfPostfix, который мы еще не модифицировали
            }
            
            
            
            
            
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
