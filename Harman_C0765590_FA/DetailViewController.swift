//
//  DetailViewController.swift
//  Harman_C0765590_FA
//
//  Created by Harmanpreet Kaur on 2020-01-24.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
     var managedContext: NSManagedObjectContext?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = labelID {

                labelID.text = detail.id
                labelName.text = detail.name
                labelDescription.text = detail.description
                labelPrice.text = "\(detail.price)"
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               // second step is context
        managedContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        let data = loadData()
        
        if data.isEmpty{
            initializeArray()
        } else{
            loadCoreData()
            
        }
        if detailItem == nil{
            if Product.products.count > 0{
                detailItem = Product.products[0]
            }
        }
        
        configureView()
    }

    var detailItem: Product? {
        didSet {
            // Update the view.
            configureView()
        }
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

           }

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
    
    func initializeArray(){
           for i in 1...10{
               let product = Product(id: "P\(i)", description: "This is product \(i)", name: "Product \(i)", price: 2.4)
               Product.products.append(product)
           }
           
           saveToCoreData()
       }
       
       func saveToCoreData(){
           
           for product in Product.products {
               print(product.name)
               
               let addProduct = NSEntityDescription.insertNewObject(forEntityName: "ProductModel", into: managedContext!)
               addProduct.setValue(product.id, forKey: "id")
               addProduct.setValue(product.name, forKey: "name")
               addProduct.setValue(product.description, forKey: "descp")
               addProduct.setValue(product.price, forKey: "price")

               
           }
           do {
               try managedContext!.save()
           } catch {
               print(error)
           }
       }
}

