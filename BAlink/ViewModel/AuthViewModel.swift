//
//  AuthViewModel.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation

protocol AuthViewModelDelegate {
    func authViewModel(didAuthorizeWithSuccess success: Bool, token: AccessToken?, error: Error?)
}

class AuthViewModel {
    
    let service = NetworkService()
    
    public init(delegate authViewModelDelegate: AuthViewModelDelegate? = nil) {
        self.delegate = authViewModelDelegate
    }
    
    var delegate: AuthViewModelDelegate?
    
    let registerEndPoint: URL? = URL(string: "https://balink-ios-learning.herokuapp.com/api/v1/auth/register")
    let loginEndPoint: URL? = URL(string: "https://balink-ios-learning.herokuapp.com/api/v1/auth/login")
    
    func generateUser(withFirstname firstname: String?, lastname: String?, username: String?, password: String?) -> UserData? {
        
        guard let firstname = firstname,
              let lastname = lastname,
              let username = username,
              let password = password
        else {
            return nil
        }

        
        return UserData(firstname: firstname, lastname: lastname, username: username, password: password)
    }
    
    func generateCredentials(withUsername username: String?, password: String?) -> UserCredentials? {
        guard let username = username,
              let password = password
        else {
            return nil
        }
        
        return UserCredentials(username: username, password: password)
    }
    
    func signUp(with user: UserData) {
        guard let signupURL = registerEndPoint else { print("Error: couldn't get sign up endpoint URL from string."); return }
        
        
        service.post(data: user.asPostParameters(), to: signupURL, decodeResponseWith: AccessToken.self) { [weak self] result in
            
            do {
                let result = try result.get()
                
                //set userdefault values & let delegate know that authorization returned OK
                UserDefaults.standard.set(result.token, forKey: K.userDefaultKeys.accessToken)
                UserDefaults.standard.set(user.username, forKey: K.userDefaultKeys.currentUsersUsername)
                UserDefaults.standard.set(user.firstname, forKey: K.userDefaultKeys.currentUsersFirstname)
                UserDefaults.standard.set(true, forKey: K.userDefaultKeys.didEverAuthorize)
                
                self?.delegate?.authViewModel(didAuthorizeWithSuccess: true, token: result, error: nil)
            } catch {
                self?.delegate?.authViewModel(didAuthorizeWithSuccess: false, token: nil, error: error)
            }
        }
    }
    
    func logIn(with credentials: UserCredentials) {
        guard let loginURL = loginEndPoint else { print("Error: couldn't get login endpoint URL from string."); return }
        
        
        service.post(data: credentials.asPostParameters(), to: loginURL, decodeResponseWith: AccessToken.self) { [weak self] result in
            
            do {
                let result = try result.get()
                
                //set userdefault values & let delegate know that authorization returned OK
                UserDefaults.standard.set(result.token, forKey: K.userDefaultKeys.accessToken)
                UserDefaults.standard.set(credentials.username, forKey: K.userDefaultKeys.currentUsersUsername)
                UserDefaults.standard.set(true, forKey: K.userDefaultKeys.didEverAuthorize)
                
                self?.delegate?.authViewModel(didAuthorizeWithSuccess: true, token: result, error: nil)
            } catch {
                self?.delegate?.authViewModel(didAuthorizeWithSuccess: false, token: nil, error: error)
            }
        }
    }
}
