//
//  ProductModel.swift
//  Harman_C0765590_FA
//
//  Created by Harmanpreet Kaur on 2020-01-24.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import Foundation

class Product{
    internal init(id: String, description: String, name: String, price: String) {
        self.id = id
        self.description = description
        self.name = name
        self.price = price
    }
    
    var id: String
    var description: String
    var name: String
    var price: String
    
    static var products = [Product]()
}
