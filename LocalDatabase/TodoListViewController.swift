//
//  ViewController.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 20/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit

class TodoListViewController:UITableViewController {

    var itemArray = [Item]()
    
  
    //folder path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItem()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Table Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell" , for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
    }
    
    //Table Delegeate Methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // row Selection
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        tableView.reloadData()
                
        //row selection animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // add new Item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem1 = Item()
            newItem1.title = textField.text!
            print(newItem1.title)
            self.itemArray.append(newItem1)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    //Store encoded data inside item.plist file
    func saveItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error in encoding item array \(error)")
        }
        self.tableView.reloadData()
    }
    //Access encoded data From item.plist file
    func loadItem(){
    
        if let data = try? Data(contentsOf: dataFilePath!){
          let decoder = PropertyListDecoder()
            do{
               itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                
            }
        }
       
    }
}

/*
 
 /*************** UserDefaults ******************/
 
    //create variable
   let defaults = UserDefaults.standard
 
 //add value
 defaults.set(itemArray, forKey: "Item")
 
 //getValue
 itemArray = defaults.array(forKey: "Item") as! [String]
 
 */
