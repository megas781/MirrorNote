//
//  EditingViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
   
   @IBOutlet weak var textView: UITextView!
   @IBOutlet weak var theNavigationItem: UINavigationItem!
   
   
   var folderToContain: Folder!
   var editableNote: Note!
   
   var primalText: String!
   
   var isNewNote: Bool!
   
   
   
   func doneButtonPressed(_ sender: UIBarButtonItem) {
      
      //Убираем клаву
      textView.resignFirstResponder()
      
   }
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      textView.delegate = self
      
      primalText = editableNote.content!
      
      //Если мы создаем новую заметку, то textView сразу становится firstResponder
      if isNewNote! {
         textView.becomeFirstResponder()
      }
      
      //В этой строчке мы говорим, чтобы класс EditingViewController исполнял свой метод updateTextView когда получал уведомление под статическим названием NSNotification.Name.UIKeyboardWillShow
      NotificationCenter.default.addObserver(/*кто получает уведомление*/self, selector: /*что делать при получении уведомления*/#selector(EditingViewController.updateTextView(notification:)), name: /*Имя уведомления*/ NSNotification.Name.UIKeyboardWillShow, object: /*хз, что это*/ nil)
      
      //"Иполняй свой метод updateTextView когда приходит уведомление с именем UIKeyboardWillHide, т.е. клавиатура сейчас исчезнет"
      NotificationCenter.default.addObserver(self, selector: #selector(EditingViewController.updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
      
   }
   
   
   //Создадим метод, обновляющий frame у textView, принимающий notification в качевсте аргумента
   func updateTextView(notification: Notification) {
      
      //Добавим кнопку Done
      
      if theNavigationItem.rightBarButtonItem == nil {
         theNavigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.doneButtonPressed(_:))), animated: false)
      } else {
         theNavigationItem.setRightBarButton(nil, animated: true)
      }
      
      
      
      //Сюда могут прийти только 2 сообщения: либо клава появится, либо исчезнет
      print("Имя соощения = \(notification.name.rawValue)")
      
      //Достанем информацию прикрепленную к notification
      let info = notification.userInfo!
      //Достанем значение под из этого словаря под ключем UIKeyboardFrameEndUserInfoKey
      let keyboardFrameScreenCoodrinades = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      
      //По-моему это на случай, если у меня горизонтальная ориентация
      let keyboardFrame = self.view.convert(keyboardFrameScreenCoodrinades, to: view.window)
      //Я с этой херотой еще разберусь...
      
      
      //
      if notification.name == Notification.Name.UIKeyboardWillShow {
         
         if textView == nil {
            print("textView = nil")
            
         } else {
            print("textView.contentInset = \(textView.contentInset)")
            
         }
         
         //Черт его знает... 
//         if navigationController?.navigationBar.frame.size.height != nil {
//            
//            textView.contentInset = UIEdgeInsets.init(top: self.navigationController!.navigationBar.frame.size.height + 20, left: 0, bottom: keyboardFrame.height, right: 0)
//            
//         } else {
//            
//            
//            
//         }
         
         textView.contentInset = UIEdgeInsets.init(top: self.navigationController!.navigationBar.frame.size.height + 20, left: 0, bottom: keyboardFrame.height, right: 0)
         
      }
      
      textView.scrollRangeToVisible(textView.selectedRange)
      
   }
   
   
   //Это чтобы прятать клаву, когда происходит касание вне textView
   //   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   //      super.touchesBegan(touches, with: event)
   //      
   //      //непосредственно метод, скрывающий textView
   //      self.textView.resignFirstResponder()
   //   }
   
   func textViewDidEndEditing(_ textView: UITextView) {
      print("textViewDidEndEditing method did execute")
   }
   
   //Постоянно перезаписываем content в editableNote, чтобы успеть сохранить данные
   func textViewDidChange(_ textView: UITextView) {
      editableNote.content = textView.text!
//      print("current content = \(editableNote.content!)")   
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      textView.isScrollEnabled = false
      
      //Загружать данные лучше во viewWillAppear
      textView.text = editableNote.content!
   }
   override func viewDidAppear(_ animated: Bool) {
      textView.isScrollEnabled = true
   }
   
   //При сворачивании viewController'a происходит сохранение
   override func viewWillDisappear(_ animated: Bool) {
      
      print("textView.text = \"\(textView.text ?? "nil text")\"")
      
      guard textView.text != "" else {
         
         editableNote.folder = nil
         
         //сохрани контекст
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
         print("Пустое поле, заметка не сохранена")
         return
      }
      
      guard editableNote.content != primalText else {
         return
      }
      
      if isNewNote! {
         
         //editableNote.content уже записан с помощью делегата, остается только дата
         editableNote.dateOfCreation = Date() as NSDate
         
         //У нас есть непустой content, дата создания и folder для editableNote уже предопределена в prepare в NotesTableViewController
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      } else {
         
         editableNote.dateOfCreation = Date() as NSDate
         
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      }
      
      NotificationCenter.default.removeObserver(self)
   }
   
   
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
}
