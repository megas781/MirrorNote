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
         
         //Logic of additional text
         if theViewController.searchController.isActive && theViewController.searchBar.text != "" {
            
            //Здесь мы точно знаем, content содержит result
            
            //Текст поиска
            let result = theViewController.searchBar.text!
            //Содержимое заметки
            var content = newValue.content!
            //Измененная строка с подсвеченными шрифтами
            var textToShow : NSMutableAttributedString = NSMutableAttributedString.init(string: "")
            
            var lengthOfPostfixContainingResult = 0
            var lengthOfDisplayedPostfix = 0
            
            //Сначала найдем длину постфикса контента, содержащего результат
            findLengthOfPostfixContainingResult: for i in 1...content.characters.count {
               if content.getPrefixWithLength(i).lowercased().contains(result.lowercased()) {
                  //Здесь вычисляем длину
                  lengthOfPostfixContainingResult = content.characters.count - (i - result.characters.count)
                  
                  break findLengthOfPostfixContainingResult
               }
            }
            
            //Здесь у нас есть длина постфикса содержащего result
            
            print("content before = \(content)")
            
            //test
            if content.getPrefixWithLength(content.characters.count - lengthOfPostfixContainingResult).contains("\n") {
               content = content.getPostfixWithLength(lengthOfPostfixContainingResult + content.getPrefixWithLength(content.characters.count - lengthOfPostfixContainingResult).getPostfixWithFirstFoundSymbol("\n").characters.count)
            }
            
            print("content after  = \(content)")
            
            print("lengthContaining = \(lengthOfPostfixContainingResult)")
            
            print("result.count = \(result.characters.count)")
            //Нужно найти первый проблел в префиксе content'a, а если его нет, то выводить всю строку, а если не умещается, то просто выводить постфикс с размером lengthOfPostfix
            
            
            
            //Новая эра - проверка на наличие пробела
            
            
            if content.getPrefixWithLength(content.characters.count - lengthOfPostfixContainingResult).contains(" ") {
               //Мы знаем, что префикс контента содержит пробел, значит свободно извлекаем по первому пробелу, и находим новую длину постфикса
               
               //lengthOfDisplayedPostfix равна постфиксу, содержащему result, и дополнительно префикса до первого пробела
               lengthOfDisplayedPostfix = lengthOfPostfixContainingResult + content.getPrefixWithLength(content.characters.count - lengthOfPostfixContainingResult).getPostfixWithFirstFoundSymbol(" ").characters.count
               
               
               //Устанавливаем textToShow и хайлайты
               textToShow = NSMutableAttributedString.init(string: content.getPostfixWithLength(lengthOfDisplayedPostfix))
               
               
               print("content.count = \(content.characters.count)")
               print("result.count = \(result.characters.count)")
               textToShow.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: NSRange.init(location: content.characters.count-lengthOfPostfixContainingResult, length: result.characters.count))
               
               print("перед добавлением textToShow = \(textToShow.string)")
               
               additionalLabel.attributedText = textToShow
               
            } else {
               //Если все вмещается, то добавляй все, а если нет, то ставь 3 точки и начинай с result, т.е. с lengthOfPostfix, который мы еще не модифицировали
               
               print("content.count = \(content.characters.count)")
               print("result.count = \(result.characters.count)")
               
               
               textToShow = NSMutableAttributedString(string: content)
               textToShow.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: NSRange.init(location: content.characters.count - lengthOfPostfixContainingResult, length: result.characters.count))
               
               
               additionalLabel.attributedText = textToShow
               
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
