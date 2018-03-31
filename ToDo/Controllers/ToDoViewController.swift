//
//  ViewController.swift
//  ToDo
//
//  Created by ABDUL MAJEED SYED on 2/21/18.
//  Copyright © 2018 ABDUL MAJEED SYED. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    var itemArray : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    let defaults = UserDefaults.standard
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
      //  print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Data1"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Data2"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Data3"
//        itemArray.append(newItem3)
//
        
    
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
   //     }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
             cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
       
        
    //        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    //Mark- Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                    //realm.delete(item)
                }
            }
                catch{
                    print("Error updating done status\(error)")
            }
        }
        tableView.reloadData()
    
//        let result = (indexPath.row)
//        let res = itemArray[indexPath.row]
//        print(result)
//        print(res)
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
//
//        itemArray?[indexPath.row].done = !itemArray[indexPath.row].done
  //      tableView.reloadData()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
  

    }
    
    @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo List" , message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.item.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch{
                    print ("Error saving new items \(error)")
                }
            }
//            print("sucess")
//            print(textField.text)
//         //   let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//
           //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//            self.saveItem()
            self.tableView.reloadData()
            }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    func saveItem() {
        do{
            try context.save()
            
        }
        catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadItems() {

        
        itemArray = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
       // let request : NSFetchRequest<Item> = Item.fetchRequest()

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name! )
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//           itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        tableView.reloadData()
      }
    
    }
    extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////        do {
////            itemArray = try context.fetch(request)
////        } catch {
////            print("Error fetching data from context \(error)")
////        }
//        loadItems(with: request,predicate: predicate)
//        print(searchBar.text!)
       tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }

    }


