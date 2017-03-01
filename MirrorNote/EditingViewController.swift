//
//  EditingViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController, UITextViewDelegate {
   
   @IBOutlet weak var textView: UITextView!
   
   var editableNote: Note!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      textView.delegate = self
      //Если нам удалось загрузить данные с помощью prepareForSegue...
      if editableNote == nil {
         
      } else {
         textView.text = editableNote.content
         
      }
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   
   func textViewDidBeginEditing(_ textView: UITextView) {
      
   }
   
}
