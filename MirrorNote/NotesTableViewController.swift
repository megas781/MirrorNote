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
      notesFetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfCreation", ascending: false)]
      
      notesFetchRequest.predicate = NSPredicate(format: "folder = %@", folder)
      
      notesFetchController = NSFetchedResultsController(fetchRequest: notesFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      //Здесь перезагружаем данные (Или загружаем, если в первый раз здесь)
      do {
         
         try notesFetchController.performFetch()
         notesList = notesFetchController.fetchedObjects!
         //Я убрал "tableView.reloadData()" в viewDidAppear, чтобы пользователь успел увидеть, что произошло с заметками
         
         //Обновляем надпись снизу
         switch notesList.count {
         case 0:
            buttonLabel.title = "No Notes"
         case 1:
            buttonLabel.title = "1 Note"
         default:
            buttonLabel.title = String(notesList.count) + " Notes"
         }
         
         
      } catch let error as NSError {
         print(error.localizedDescription)
      }
      
      if tableView.indexPathForSelectedRow != nil {
         tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
      }
      
   }
   
   override func viewDidAppear(_ animated: Bool) {
      tableView.reloadData()
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
         noteToDeliver.folder = dvc.folderToContain
         dvc.editableNote = noteToDeliver
         
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
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Обновляем надпись снизу
            switch self.notesList.count {
            case 0:
               self.buttonLabel.title = "No Notes"
            case 1:
               self.buttonLabel.title = "1 Note"
            default:
               self.buttonLabel.title = String(self.notesList.count) + " Notes"
            }
            
            tableView.reloadData()
            
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
         
      }
      
      return [delete]
   }
   
}
