//
//  APIRequestLoader.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/10.
//

import Foundation
import Alamofire

class APIRequestLoader<T: APIServiceProtocol> {
    
    let apiService: T
    
    var urlSession: Alamofire.Session = {
        
        let configuration = URLSessionConfiguration.default
        
        configuration.urlCache = nil
        
        return Session(configuration: configuration)
        
    }()
    
    init(apiService: T, urlSession: Alamofire.Session = .default) {
        
        self.apiService = apiService
        
        self.urlSession = urlSession
        
    }
    
    func loadAPIRequest(requestData: T.RequestDataType, completionHandler: @escaping ((T.ResponseDataType?, Error?)) -> Void) {
        
        do {
            
            let urlRequest = try apiService.makeRequest(from: requestData)
            
            urlSession.request(urlRequest).response { response in
                switch response.result {
                    
                case .success:
                    guard let data = response.data else { return completionHandler((nil, nil)) }
                    
                    do {
                        
                        let response = try self.apiService.parseResponse(from: data)
                        completionHandler((response, nil))
                        
                    } catch {
                        
                        completionHandler((nil, error))
                    }
                    
                case .failure(let error):
                    completionHandler((nil, error))
                }
            }
            
        } catch {
            
            return completionHandler((nil, error))
            
        }
    }
    
}
