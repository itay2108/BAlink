//
//  FavoritesViewModel.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit

//favoritesViewModel has all of productsViewModels functions, it is just initiated with a different title and dataSource for the UICollectionview/
class FavoritesViewModel: ProductsViewModel {
    
    convenience init() {
        self.init(selectedCategory: "Favorites", products: [])
    }
    
    override func dataSource() -> [Product] {
        return favoriteProducts
    }
}
