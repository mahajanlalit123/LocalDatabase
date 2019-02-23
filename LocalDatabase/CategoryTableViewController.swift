//
//  CategoryTableViewController.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 22/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItem()
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell" , for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "id_showItem", sender: self)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem1 = Category()
            newItem1.name = textField.text!
        
            self.saveItem(category: newItem1)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
   //Save Category Item
    func saveItem(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving Cotext \(error)")
        }
        self.tableView.reloadData()
    }
   
    //Access Category Item
    func loadItem(){
        
      categories = realm.objects(Category.self)
        tableView.reloadData()
    }

}

