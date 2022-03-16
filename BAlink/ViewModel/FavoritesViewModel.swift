//
//  FavoritesViewModel.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit
import Realm

class FavoritesViewModel: ProductsViewModel {
    
    convenience init() {
        self.init(selectedCategory: "Favorites", products: [])
    }
    
    override func dataSource() -> [Product] {
        return favoriteProducts
    }
}
