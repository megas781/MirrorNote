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
         
         
         //Перед началом логики нужно объявить основные переменные
         let noteContent = newValue.content!
         
         var content = noteContent.singleLine()
         
         
         var textToShow = NSMutableAttributedString(string: "")
         
         
         
         //Если в поисковике что-то написано, то продолжаем
         if theViewController.searchController.isActive && theViewController.searchBar.text != "" {
            
            //Если контент содержит текст searchBar'a, то продолжаем
            if content.lowercased().contains(theViewController.searchBar.text!.lowercased()) {
               
               
               let result = theViewController.searchBar.text!
               
               var postfixContainingResult = ""
               
               //Сейчас мы найдем значение для postfixContainingResult
               exitFromSearching: for i in 1...content.length {
                  if content.getPrefixWithLength(i).lowercased().contains(result.lowercased()) {
                     
                     postfixContainingResult = content.getPostfixWithLength(content.length - i + result.length)
                     
                     break exitFromSearching
                  }
               }
               
               
               
               //Здесь у нас есть postfixContainingResult
               //Теперь нужен displayedPostfix
               
               var displayedPostfix: String? = nil
               
               //Если после искомого слова есть пробел, то в displayedPostfix вставляем постфикс с необрезанным постфиксом
               if content.getPrefixWithLength(content.length - postfixContainingResult.length).contains(" ") {
                  
                  displayedPostfix = content.getPostfixWithLength(content.getPrefixWithLength(content.length - postfixContainingResult.length).getPostfixWithFirstFoundSymbol(" ").length + postfixContainingResult.length)
                 
//                  print("displayedPostfix = \"\(displayedPostfix!)\"")
                  
               } else {
//                  print("displayedPostfix = \"nil\"")
//                  print("postfixContainingResult = \"\(postfixContainingResult)\"")
//                  
               }
               
               
               
               //Если displayedPostfix пустой...
               if displayedPostfix == nil {
                  //Тогда мы знаем, что первое слово содержит result
                  
                  //Сколько символов допустимо ДО result в content
                  var allowedNumberOfSymbols : Int = 10
                  
                  
                  //В таком случае, если кол-во знаков перед искомым result не превышает 6 знаков, то мы пишем троеточние —> шесть знаков до -> postfixContainingResult
                  
                  
                  if content.getPrefixWithLength(content.length - postfixContainingResult.length).length <= allowedNumberOfSymbols {
                     
                     //Префикс меньше шести, значит просто выводим content:
                     textToShow = NSMutableAttributedString(string: content)
                     
                     textToShow.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: .init(location: content.length - postfixContainingResult.length, length: result.length))
                     
                     
                     
                     additionalLabel.attributedText = textToShow
                     
                  } else {
                     
                     textToShow = NSMutableAttributedString(string: "..." + content.getPostfixWithLength(postfixContainingResult.length + allowedNumberOfSymbols - 3 /* три, потому что три точки */))
                     
                     textToShow.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: .init(location: textToShow.string.length - postfixContainingResult.length, length: result.length))
                     
                     
                     
                     additionalLabel.attributedText = textToShow
                     
                     
                  }
                  
               } else {
                  //Просто отобразим displayedPostfix
                  
                  textToShow = NSMutableAttributedString(string: displayedPostfix!)
                  textToShow.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: .init(location: displayedPostfix!.length - postfixContainingResult.length, length: result.length))
                  
                  additionalLabel.attributedText = textToShow
                  
               }
               
            }
         }
         //Иначе, если есть вторая строчка, заносим ее в additional
         else {
            
            if noteContent.contains("\n") {
            
               additionalLabel.text = noteContent.getPostfixWithLength(noteContent.characters.count - noteContent.getPrefixWithFirstFoundSymbol("\n").characters.count - 1)
               
               //
               if additionalLabel.text!.isInvisible {
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
