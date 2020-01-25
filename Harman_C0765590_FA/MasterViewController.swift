//
//  MasterViewController.swift
//  Harman_C0765590_FA
//
//  Created by Harmanpreet Kaur on 2020-01-24.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
//    var products = [Product]()

    var managedContext: NSManagedObjectContext?

    var name, id, desc: String?
    var price: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        print("Master")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // second step is context
        managedContext = appDelegate.persistentContainer.viewContext
        
//        initializeArray()
               
//        let data = loadData()
//
//        if data.isEmpty{
//            initializeArray()
//        } else{
//            loadCoreData()
//            Product.products = []
//            for product in data{
//                let p = Product(id: product.value(forKey: "id") as! String, description: product.value(forKey: "descp") as! String, name: product.value(forKey: "name") as! String, price: product.value(forKey: "price") as! Double)
//                Product.products.append(p)
//            }
//        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {

        
        let alertController = UIAlertController(title: "New product", message: "Enter details", preferredStyle: .alert)
        
        alertController.addTextField { (txtId) in
            self.id = txtId.text
        }
        alertController.addTextField { (txtName) in
            self.name = txtName.text
        }
        alertController.addTextField { (txtDesc) in
            self.desc = txtDesc.text
            
        }
        alertController.addTextField { (txtPrice) in
            self.price = Double(txtPrice.text ?? "0.0") ?? 0.0
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (saveToCore) in
            
            let addProduct = NSEntityDescription.insertNewObject(forEntityName: "ProductModel", into: self.managedContext!)
            addProduct.setValue(self.id, forKey: "id")
            addProduct.setValue(self.name, forKey: "name")
            addProduct.setValue(self.desc, forKey: "descp")
            addProduct.setValue(self.price, forKey: "price")

            do {
                try self.managedContext!.save()
            } catch {
                print(error)
            }

        }
        
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        loadCoreData()
//        Product.products.append(loadData())
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func loadCoreData(){
        Product.products = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")
        
        do {
            let results = try managedContext!.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for r in results as! [NSManagedObject]{
                    let p = Product(id: r.value(forKey: "id") as! String, description: r.value(forKey: "descp") as! String, name: r.value(forKey: "name") as! String, price: r.value(forKey: "price") as! Double)
                    Product.products.append(p)
                }
            }
        } catch {
            print(error)
        }
        tableView.reloadData()

    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = Product.products[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Product.products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = Product.products[indexPath.row].name
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Product.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


   ////////
    
    func loadData() -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")
        
        do {
            let results = try managedContext!.fetch(fetchRequest)
            
            
            if results is [NSManagedObject] {
                print("count...\(results.count)")
                return results as! [NSManagedObject]
            }
        } catch {
            print(error)
        }

        return [NSManagedObject]()
        
    }
        
}

