//
//  CategoryViewController.swift
//  Todomy
//
//  Created by Jason on 2018/8/7.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    

    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destination?.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    
    
    // MARK: - Button Action Methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let addOption = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            
            if let text = textField.text
            {
                newCategory.name = text
                
                //self.categoryArray.append(newCategory) //auto update
                
                self.save(category: newCategory)
            }
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addOption)
        alert.addAction(cancelOption)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion:nil)
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category)
    {
        do
        {
            try realm.write {
                realm.add(category)
            }
        }
        catch
        {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadCategories()
    {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
       
    }
    
    
}
