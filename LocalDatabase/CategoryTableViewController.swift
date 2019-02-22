//
//  CategoryTableViewController.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 22/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [Catgory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItem()
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell" , for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "id_showItem", sender: self)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem1 = Catgory(context: self.context)
            newItem1.name = textField.text!
            self.categories.append(newItem1)
            
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
   //Save Category Item
    func saveItem(){
        
        do{
            try self.context.save()
        }catch{
            print("Error in saving Cotext \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
    //Access Category Item
    func loadItem(with request : NSFetchRequest<Catgory> = Catgory.fetchRequest()){
        
        do{
            categories = try self.context.fetch(request)
        }catch{
            print("Error in loading Item \(error)")
        }
        tableView.reloadData()
    }

}
