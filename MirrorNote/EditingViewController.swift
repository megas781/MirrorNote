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
   
   var editableNote: Note!
   
   
   
   func doneButtonPressed(_ sender: UIBarButtonItem) {
      
      //Убираем клаву
      textView.resignFirstResponder()
      
   }
   
   @IBOutlet weak var theNavigationItem: UINavigationItem!
   

   override func viewDidLoad() {
      super.viewDidLoad()
      
      textView.delegate = self
      
      
      
//      textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      print("mark")
      
      
      //Если нам удалось загрузить данные с помощью prepareForSegue...
      if editableNote != nil {
         textView.text = editableNote.content
      }
      
      //В этой строчке мы говорим, чтобы класс EditingViewController исполнял свой метод updateTextView когда получал уведомление под статическим названием NSNotification.Name.UIKeyboardWillShow
      NotificationCenter.default.addObserver(/*кто получает уведомление*/self, selector: /*что делать при получении уведомления*/#selector(EditingViewController.updateTextView(notification:)), name: /*Имя уведомления*/ NSNotification.Name.UIKeyboardWillShow, object: /*хз, что это*/ nil)
      
      //"Иполняй свой метод updateTextView когда приходит уведомление с именем UIKeyboardWillHide, т.е. клавиатура сейчас исчезнет"
      NotificationCenter.default.addObserver(self, selector: #selector(EditingViewController.updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
   
   func textViewDidBeginEditing(_ textView: UITextView) {
      
      
      
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      textView.isScrollEnabled = false
   }
   override func viewDidAppear(_ animated: Bool) {
      textView.isScrollEnabled = true
   }
   
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
   
}
