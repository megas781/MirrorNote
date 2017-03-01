//
//  NotesTableViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData
class NotesTableViewController: UITableViewController {
   
   @IBOutlet weak var buttonLabel: UIBarButtonItem!
   
   var folder : Folder!
   var notesList: [Note] = []
   
   var notesFetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
   var notesFetchController: NSFetchedResultsController<Note>!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      notesList = folder.notes!.sortedArray(using: [NSSortDescriptor.init(key: "self.dateOfCreation", ascending: true)]) as! [Note]
      print("notesList после присваивания = \(notesList)")
      
      
      
      
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return notesList.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesTableViewCell
      
      let info = notesList[indexPath.row]
      
      cell.note = info
      
      return cell
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "FromSelectedCellToEditing" {
         let dvc = segue.destination as! EditingViewController
         
         //Передаем заметку в EditingViewController
         dvc.editableNote = self.notesList[tableView.indexPathForSelectedRow!.row]
         
      }
   }
   
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
         
         //Удаляем из массива
         let objectToDelete = self.notesList.remove(at: indexPath.row)
         
         //Удаляем из хранилища и пытаемся сохранить
         context.delete(objectToDelete)
         
         do {
            try context.save()
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      }
      
      return [delete]
   }
   
}
