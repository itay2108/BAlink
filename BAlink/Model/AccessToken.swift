//
//  AccessToken.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation

struct AccessToken: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
