//
//  K.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation
import UIKit

struct K {
    
    struct colors {
        static let accentColor = UIColor(named: "AccentColor") ?? .purple
        static let backgroundColor = UIColor(named: "background") ?? .systemBackground
        static let tabBarColor = UIColor(named: "tabBarColor") ?? .systemBackground
    }
    
    struct userDefaultKeys {
        static let accessToken = "accessToken"
        static let currentUsersFirstname = "currentUsersFirstname"
        static let currentUsersLastname = "currentUsersLastname"
        static let currentUsersUsername = "currentUsersUsername"
        static let didEverAuthorize = "didEverAuthorize"
    }
    
    struct images {
        static let heart = UIImage(systemName: "heart")
        static let filledHeart = UIImage(systemName: "heart.fill")
        static let logotype = UIImage(named: "logotype")
    }
}
