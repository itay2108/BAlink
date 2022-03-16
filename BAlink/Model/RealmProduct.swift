//
//  RealmProduct.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit
import RealmSwift

class RealmProduct: Object {
    @Persisted var id: String = ""
    @Persisted var title: String = ""
    @Persisted var type: String = ""
    @Persisted var productDescription: String = ""
    @Persisted var price: Int = 0
    @Persisted var rating: Int = 0
    @Persisted var imageUrl: String = ""

    func asProduct() -> Product {
        let product = Product(id: self.id, title: self.title, type: self.type, description: self.productDescription, price: self.price, rating: self.rating, imageUrl: self.imageUrl)
        
        return product
    }
}
