//
//  DetailViewController.swift
//  Harman_C0765590_FA
//
//  Created by Harmanpreet Kaur on 2020-01-24.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
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
        // Do any additional setup after loading the view.
        
        if detailItem == nil{
            detailItem = Product.products[0]
        }
        configureView()
    }

    var detailItem: Product? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

