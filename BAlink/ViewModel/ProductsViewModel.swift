//
//  ProductViewModel.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit
import Alamofire
import RealmSwift

protocol ProductsViewModelDelegate {
    func productsViewModel(favoriteProductsDidUpdateTo products: [Product])
}

extension ProductsViewModelDelegate {
    func productsViewModel(favoriteProductsDidUpdateTo products: [Product]) {
        
    }
}

class ProductsViewModel {
    
    let username = UserDefaults.standard.string(forKey: K.userDefaultKeys.currentUsersUsername)
    
    let category: String
    var products: [Product]
    var favoriteProducts: [Product] = [] {
        didSet {
            //update delegate and database of the new favorite products
            delegate?.productsViewModel(favoriteProductsDidUpdateTo: favoriteProducts)
            RealmManager.shared.realmFavorites(update: favoriteProducts, forUser: username)
        }
    }
    
    var delegate: ProductsViewModelDelegate?
    
    init(selectedCategory: String, products: [Product]) {
        self.products = products
        self.category = selectedCategory
        
        favoriteProducts = RealmManager.shared.realmFavorites(getProductsOf: username)
    }
    
    func isMarkedAsFavorite(_ product: Product) -> Bool {
        let favoriteIDs = favoriteProducts.map { $0.id }
        
        return favoriteIDs.contains(product.id) ? true : false
    }
    
    func dataSource() -> [Product] {
        return products
    }
    
    //MARK: - Image loading
    
    private var loadedImages = [String: UIImage]()
    private var runningRequests = [UUID: DataRequest]()
    
    func getCharacterImage(of url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
          completion(.success(image))
          return nil
        }

        let uuid = UUID()
        let request = AF.request(url)
        
        request.response { response in
                
            defer { self.runningRequests.removeValue(forKey: uuid) }
                
                guard let imageData = response.value as? Data,
                      let image = UIImage(data: imageData, scale: 1) else {
                    completion(.failure(NetworkError.parseError))
                    return
                }
                
                completion(.success(image))
            }
        
        runningRequests[uuid] = request
        return uuid
    }
    
    func cancelRequest(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
    
    //MARK: - Favorite Methods
    
    func addToFavorites(_ product: Product) {
        favoriteProducts.append(product)
    }
    
    func removeFromFavorites(_ product: Product) {
        favoriteProducts.removeAll(where: { $0.id == product.id })
    }
    

    
    
}
