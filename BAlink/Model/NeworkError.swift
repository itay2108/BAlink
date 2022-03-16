//
//  FetchError.swift
//  Gini-apps
//
//  Created by itay gervash on 08/03/2022.
//

import Foundation

enum NetworkError: Error {
    case requestError(error: Error)
    case parseError
    case postError(error: Error)
    case userNameError
    case passwordError
}
