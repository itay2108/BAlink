//
//  Service.swift
//  BAlink
//
//  Created by itay gervash on 14/03/2022.
//

import Foundation
import Alamofire

class NetworkService {
    
    func fetchData<T: Codable>(from url: URL, with headers: HTTPHeaders?, decodeWith: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let request = AF.request(url, headers: headers).validate(statusCode: 200..<300)
        
        request.responseDecodable(of: T.self) { response in
            
            guard response.error == nil
            else {
                completion(.failure(response.error!))
                return
            }
            
            if let result = response.value {
                completion(.success(result))
            } else {
                completion(.failure(NetworkError.parseError))
            }
        }
    }
    
    func post<T: Codable>(data: Dictionary<String, Any>, to url: URL, decodeResponseWith decoder: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default).validate(statusCode: 200..<300)
        
            .responseDecodable(of: decoder) { response in
                guard response.error == nil
                else {
                    completion(.failure(response.error!))
                    return
                }
                
                if let result = response.value {
                    completion(.success(result))
                } else {
                    completion(.failure(NetworkError.parseError))
                }
            }
    }
    
    
    
}
