//
//  UserInfo.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation

struct UserData: Codable {
    let firstname: String
    let lastname: String
    let username: String
    let password: String
    
    func asPostParameters() -> Dictionary<String, String> {
        return [
            "firstname": firstname,
            "lastname": lastname,
            "username": username,
            "password": password
        ]
    }

}
