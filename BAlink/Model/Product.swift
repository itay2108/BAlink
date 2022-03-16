//
//  Product.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import Foundation
import UIKit

struct Product: Codable {
    let id: String
    let title: String
    let type: String
    let description: String
    let price: Int
    let rating: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case type
        case description
        case price
        case rating
        case imageUrl
    }
    
    func asRealmProduct() -> RealmProduct {
            let realmObject = RealmProduct()
            realmObject.id = self.id
            realmObject.title = self.title
            realmObject.type = self.type
            realmObject.productDescription = self.description
            realmObject.price = self.price
            realmObject.rating = self.rating
            realmObject.imageUrl = self.imageUrl

        return realmObject
    }
}
