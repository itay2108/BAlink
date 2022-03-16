//
//  FavoritesDatabase.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import UIKit
import RealmSwift

class User: Object {
    
    @Persisted var username: String = ""
    @Persisted var favorites = List<RealmProduct>()

}
