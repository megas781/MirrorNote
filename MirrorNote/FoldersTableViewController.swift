//
//  FoldersTableViewController.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit
import CoreData

var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class FoldersTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBAction func refresh(_ sender: UIBarButtonItem) {
      
   }
   
   
   @IBAction func addNewFolder(_ sender: UIBarButtonItem) {

      if ac.textFields!.count < 1 {
         ac.addTextField { (textField) in
            textField.keyboardType = .default
            textField.placeholder = "Folder name"
            textField.delegate = self
         }
      }
      
      
      if ac.actions.count < 2 {
         //Переопределим кнопку create
         create = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            let newFolder = Folder(context: context)
            
            newFolder.name = ac.textFields!.first!.text!
            newFolder.dateOfCreation = Date() as NSDate
            //Всегда при объявлении объявляй .notes как [], чтобы не было nil. Это может пригодиться
            newFolder.notes = []
            
            self.folderList.append(newFolder)
            
            do {
               try context.save()
               try self.foldersFetchController.performFetch()
            } catch let error as NSError {
               print("Не удалось сохранить данные: \(error.localizedDescription)")
            }
            
            self.tableView.reloadData()
            
         })
         
         create.isEnabled = false
         
         ac.addAction(create)
      }
      
      
      self.present(ac, animated: true, completion: nil)
      
   }
   
   var foldersFetchRequest: NSFetchRequest<Folder>! = Folder.fetchRequest()
   
   var foldersFetchController: NSFetchedResultsController<Folder>!
   
   var folderList: [Folder]! = []
   
   
   //Это на всякий случай
   var notesFetchController: NSFetchedResultsController<Note>!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.tableFooterView = UIView(frame: .zero)
      
      
      //Добавляем лишь однажды
      ac.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
      
      
      //Смотрим: если хранилище с папками пустое, то создаем новую папку под названием "Default folder"
      do {
         foldersFetchRequest.sortDescriptors = []
         foldersFetchController = NSFetchedResultsController(fetchRequest: foldersFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
         try foldersFetchController.performFetch()
         folderList = foldersFetchController.fetchedObjects
         //Если хранилище пустое, то...
         if folderList.isEmpty {
            
            let defaultFolder = Folder(context: context)
            
            defaultFolder.name = "Default Folder"
            defaultFolder.dateOfCreation = Date() as NSDate
            defaultFolder.notes = []
            
            folderList.append(defaultFolder)
            
            //Создана дефолтная папка, добавлена в folderList, значит теперь сохраняем контект
            do {
               try context.save()
            } catch let error as NSError {
               print("Не удалось сохранить данные: \(error.localizedDescription)")
            }
            
         } else {
            // do nothing
            print("Успешное извлеение данных из хранилища")
         }
         
         
      } catch let error as NSError {
         print("Не удалось получить данные о папках: \(error.localizedDescription)")
      }
      
      let m = Note(context: context)
      m.content = "Первая запись бла бла бла дбла ббал"
      m.dateOfCreation = Date() as NSDate
      let n = Note(context: context)
      n.content = "Вторая запись бла бла бла блаб лабл ба "
      n.dateOfCreation = Date() as NSDate
      
      folderList[1].notes = folderList[1].notes!.addingObjects(from: [m,n]) as NSSet!
      
   }
   
   
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return folderList.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoldersTableViewCell
      
      let info = folderList[indexPath.row]
      
      cell.folder = info
      
      return cell
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
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      switch segue.identifier! {
      case "fromFolderToNotes":
         
         let dvc = segue.destination as! NotesTableViewController
         
         dvc.folder = foldersFetchController.object(at: tableView.indexPathForSelectedRow!)
         
         
      default:
         break
      }
      
      
   }
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
         
         do {
            
            let objectToRemove = self.foldersFetchController.object(at: indexPath)
            context.delete(objectToRemove)
            self.folderList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            try context.save()
            try self.foldersFetchController.performFetch()
            
            
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         
      }
      
      
      return [remove]
   }
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if range.length > 1 && string == "" && textField.text!.characters.count <= range.length || textField.text!.characters.count == 1 && string == "" {
         
         create.isEnabled = false
      } else {
         
         create.isEnabled = true
      }
      
      return true
   }
}

//Кнопка create для создания папки. Сделал fileprivate и объявил вне класса, чтобы метод делегата textField видел свойство create.isEnabled
fileprivate var create = UIAlertAction()
fileprivate let ac = UIAlertController(title: "New Folder", message: "Type the name of folder", preferredStyle: .alert)
