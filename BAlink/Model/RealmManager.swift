//
//  RealmManager.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    let realm = try? Realm()
    
    static let shared = RealmManager()
    
    func realmFavorites(getProductsOf user: String?) -> [Product] {
        guard let realm = realm,
              let username = user else {
            return []
        }
        
        let userObject = realm.objects(User.self).where {
            $0.username == username
        }.last
        
        
        var favorites: [Product] = []
        
        if let favoritesList = userObject?.favorites {
            for favorite in favoritesList {
                favorites.append(favorite.asProduct())
            }
        }
        
        return favorites
    }
    
    
    func realmFavorites(update products: [Product], forUser user: String?) {
        guard let realm = realm,
              let username = user else {
            return
        }
        
        let userObject = User()
        userObject.username = username
        
        for product in products {
            userObject.favorites.append(product.asRealmProduct())
        }
        
        do {
            try realm.write {
                //delete old copies
                let objectsToDelete = (realm.objects(User.self).where {
                    $0.username == username
                })
                
                realm.delete(objectsToDelete)
                
                //write new object
                realm.add(userObject)
            }
        } catch {
            print(error)
        }
        
    }
}
