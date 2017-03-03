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
      
      tableView.tableFooterView = UIView(frame: .zero)
      
      
      //Раз и навсегда инициализируем наш notesFetchController
      notesFetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfCreation", ascending: true)]
      
      notesFetchRequest.predicate = NSPredicate(format: "folder = %@", folder)
      
      notesFetchController = NSFetchedResultsController(fetchRequest: notesFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      //Здесь перезагружаем данные (Или загружаем, если в первый раз здесь)
      do {
         
         try notesFetchController.performFetch()
         notesList = notesFetchController.fetchedObjects!
         tableView.reloadData()
      } catch let error as NSError {
         print(error.localizedDescription)
      }
      
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
      
      cell.note = notesList[indexPath.row]
      
      return cell
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      switch segue.identifier! {
      case "FromSelectedCellToEditing":
         
         let dvc = segue.destination as! EditingViewController
         
         dvc.folderToContain = self.folder
         dvc.editableNote = notesList[tableView.indexPathForSelectedRow!.row]
         dvc.isNewNote = false
         
      case "createNewNote":
         
         let dvc = segue.destination as! EditingViewController
         dvc.folderToContain = self.folder
         
         let noteToDeliver = Note(context: context)
         noteToDeliver.content = ""
         //Добавлю эту дату, которую нужно будет заменить, просто для того, чтобы не было nil
         noteToDeliver.dateOfCreation = Date() as NSDate
         dvc.isNewNote = true
         
      default:
         break
      }
      
      
   }
   
    // MARK: - Navigation
    
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
         
         do {
            
            context.delete(self.notesList.remove(at: indexPath.row))
            try context.save()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
         
      }
      
      return [delete]
   }
   
}
