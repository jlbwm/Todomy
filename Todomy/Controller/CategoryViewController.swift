//
//  CategoryViewController.swift
//  Todomy
//
//  Created by Jason on 2018/8/7.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
    }
    
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        if let colorString = categoryArray?[indexPath.row].hasColor
        {
            cell.backgroundColor = UIColor(hexString: colorString)
            
            guard let color = UIColor(hexString: colorString) else {fatalError()}
            
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true )
        }
        
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
                
                newCategory.hasColor = UIColor.randomFlat.hexValue()
                
                
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
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let selectedCategory = self.categoryArray?[indexPath.row]
        {
            do
            {
                try self.realm.write
                {
                    self.realm.delete(selectedCategory)
                }
            }
            catch
            {
                print("Error deleting context \(error)")
                
            }
        }
        
    }
    
    
}


