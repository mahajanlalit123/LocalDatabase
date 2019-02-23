//
//  ViewController.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 20/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController:UITableViewController {

    var itemArray : Results<Item>?
    var realm = try! Realm()
    //folder path
    
    var selectedCategory : Category?{
        didSet{
            loadItem()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    //Table Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell" , for: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = itemArray?[indexPath.row].title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item Found"
        }
        
        return cell
    }
    
    //Table Delegeate Methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let tempitem = itemArray?[indexPath.row]{
         
            do{
                try realm.write {
                    //realm.delete(tempitem)
                    tempitem.done = !tempitem.done
                }
            }catch{
             print(error)
            }
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
            
            
            if let currentCategory = self.selectedCategory{
                do{
               try self.realm.write {
                    let newItem1 = Item()
                    newItem1.title = textField.text!
                    newItem1.dateCreated = Date()
                    currentCategory.items.append(newItem1)
                }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //Access encoded data From item.plist file
    func loadItem(){

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
 }
//MARK: - SearchBar Method
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if(searchBar.text?.count == 0){
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
