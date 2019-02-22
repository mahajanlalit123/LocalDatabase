//
//  ViewController.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 20/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController:UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    //folder path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var selectedCategory : Catgory?{
        didSet{
            loadItem()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        /*if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }*/
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItem()
        tableView.reloadData()
                
        //row selection animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // add new Item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem1 = Item(context: self.context)
            newItem1.title = textField.text!
            newItem1.done = false
            newItem1.parentCategory = self.selectedCategory
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
       
        do{
           try self.context.save()
        }catch{
            print("Error in saving Cotext \(error)")
        }
        self.tableView.reloadData()
    }
    //Access encoded data From item.plist file
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){

        let categoryPredect = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            
            //Multiple Condition Check
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredect,additionalPredicate])
        }else{
            request.predicate = categoryPredect
        }
       
        do{
            itemArray = try self.context.fetch(request)
        }catch{
            print("Error in loading Item \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar Method
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
        
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




/*
 /*************** UserDefaults ******************/
 
    //create variable
   let defaults = UserDefaults.standard
 
 //add value
 defaults.set(itemArray, forKey: "Item")
 
 //getValue
 itemArray = defaults.array(forKey: "Item") as! [String]
 
 */
