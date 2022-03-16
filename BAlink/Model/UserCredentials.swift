//
//  UserCredentials.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation

struct UserCredentials: Codable {
    
    let username: String
    let password: String
    
    func asPostParameters() -> Dictionary<String, String> {
        return [
            "username": username,
            "password": password
        ]
    }

}
