//
//  APIRequestLoader.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/10.
//

import Foundation

class APIRequestLoader<T: APIServiceProtocol> {
    
    let apiService: T
    
    let urlSession: URLSession
    
    init(apiService: T, urlSession: URLSession = .shared) {
        
        self.apiService = apiService
        
        self.urlSession = urlSession
        
    }
    
    func loadAPIRequest(requestData: T.RequestDataType, completionHandler: @escaping ((T.ResponseDataType?, Error?)) -> Void) {
        
        do {
            
            let urlRequest = try apiService.makeRequest(from: requestData)
            
            urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
                
                guard let data = data else { return completionHandler((nil, error)) }
                
                do {
                    
                    guard let parseResponse = try self?.apiService.parseResponse(from: data) else { return completionHandler((nil, nil)) }
                    
                    completionHandler((parseResponse, nil))
                    
                } catch {
                    
                    completionHandler((nil, error))
                    
                }
                
            }.resume()
            
        } catch {
            
            return completionHandler((nil, error))
            
        }
    }
    
}
