//
//  ViewController.swift
//  ToDo
//
//  Created by ABDUL MAJEED SYED on 2/21/18.
//  Copyright © 2018 ABDUL MAJEED SYED. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        
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
        
            loadItems()
        
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
   //     }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    //Mark- Tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveItem()
        

    }
    
    @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo List" , message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print("sucess")
//            print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
           //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItem()
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array")
        }
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
                catch {
                    print("Error decoding item array, \(error)")
                }
            }
        }
    }


