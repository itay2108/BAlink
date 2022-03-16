//
//  CategoryViewModel.swift
//  BAlink
//
//  Created by itay gervash on 15/03/2022.
//

import Foundation
import Alamofire
import UIKit

protocol CategoryViewModelDelegate {
    func categoryViewModel(didGetProducts products: [Product])
    func categoryViewModel(didFailGettingProductsWith error: Error)
}

extension CategoryViewModelDelegate {
    func categoryViewModel(didFailGettingProductsWith error: Error) {
        print(error)
    }
}

class CategoryViewModel {
    
    let service = NetworkService()
    
    public init(delegate categoryViewModelDelegate: CategoryViewModelDelegate? = nil) {
        self.delegate = categoryViewModelDelegate
    }
    
    var delegate: CategoryViewModelDelegate?
    
    private let def = UserDefaults.standard
    
    private let productsEndPoint: URL? = URL(string: "https://balink-ios-learning.herokuapp.com/api/v1/products")
    private let token = UserDefaults.standard.string(forKey: K.userDefaultKeys.accessToken)
    
    var allProducts: [Product]?
    
    func getProducts() {
        guard let token = token,
              let url = productsEndPoint else {
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        service.fetchData(from: url, with: headers, decodeWith: [Product].self) { [weak self] result in
            do {
                let result = try result.get()
                
                self?.delegate?.categoryViewModel(didGetProducts: result)
                self?.allProducts = result
            } catch {
                self?.delegate?.categoryViewModel(didFailGettingProductsWith: error)
            }
        }
    }
    
    func personalGreeting() -> String {
        if let firstName = def.string(forKey: K.userDefaultKeys.currentUsersFirstname) {
            return "Hello, \(firstName.capitalized)"
        } else if let username = def.string(forKey: K.userDefaultKeys.currentUsersUsername) {
            return "Hello, \(username.capitalized)"
        } else {
            return "Hello"
        }
    }
    
    func productViewController(with products: [Product], of category: String) -> ProductsViewController {
        let viewModel = ProductsViewModel(selectedCategory: category, products: products)
        let controller = ProductsViewController(with: viewModel)
        
        return controller
    }
    
    func errorAlert(with message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Couldn't load products", message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(dismiss)
        
        return alert
    }
    
    func logoutAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: "Are you sure you want to log out?**", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let logout = UIAlertAction(title: "Log out", style: .destructive) { [weak self] action in
            guard let delegateViewController = self?.delegate as? UIViewController else {
                return
            }
            
            UserDefaults.standard.set(nil, forKey: K.userDefaultKeys.currentUsersUsername)
            UserDefaults.standard.set(nil, forKey: K.userDefaultKeys.currentUsersFirstname)
            UserDefaults.standard.set(nil, forKey: K.userDefaultKeys.currentUsersLastname)
            UserDefaults.standard.set(nil, forKey: K.userDefaultKeys.accessToken)
            
            
            delegateViewController.view.window?.rootViewController = HiddenNavigationController(rootViewController: AuthViewController())
            delegateViewController.view.window?.makeKeyAndVisible()
        }
        
        alert.addAction(logout)
        alert.addAction(cancel)
        
        return alert
    }
    
}
