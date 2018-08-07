//
//  TodoListViewController.swift
//  Todomy
//
//  Created by Jason on 2018/8/6.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    //Table View dataSource methods
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
    

    //Table View delegate methods
    
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
            
            let newItem = Item()
        
            if let textField = textField.text
            {
                newItem.title = textField
                
                self.itemArray.append(newItem)
                
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                //会导致崩溃，UserDefault 不接受用户定义的类，结构数组，字典等。
                
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
        let encoder = PropertyListEncoder()
        
        do
        {
            let data = try encoder.encode(itemArray)
            
            try data.write(to: dataFilePath!)
            
        }
            
        catch
        {
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let deCoder = PropertyListDecoder()
            
            do{
                itemArray = try deCoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error decoding error, \(error)")
            }
        }
    }

}
