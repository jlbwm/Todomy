//
//  TodoListViewController.swift
//  Todomy
//
//  Created by Jason on 2018/8/6.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
    }

    // MARK: - Table View dataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    

    // MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todomy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in

            let newItem = Item(context: self.context)
        
            if let textField = textField.text
            {
                newItem.title = textField
                newItem.done = false
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manupulation Methods
    func saveItems()
    {
        do
        {
            try context.save()
        }
            
        catch
        {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching from the context \(error)")
        }
    }

}
