//
//  BaseRequestProtocol.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/10.
//

import Foundation

protocol BaseRequestProtocol {

    var host: String { get }
    
    var scheme: String { get }
    
    var path: String { get }
    
    var queryItems: [URLQueryItem]? { get }
    
    var headers: [String : String]? { get }
    
    var body: Data? { get }
    
    var method: HTTPMethod { get }
    
    var timeoutInterval: TimeInterval { get }
    
}

extension BaseRequestProtocol {
    
    func asURLRequest() throws -> URLRequest {
        
        var components = URLComponents()
        
        components.host = host
        
        components.scheme = scheme
        
        components.path = path
        
        components.queryItems = queryItems

        
        var urlRequest = URLRequest(url: (components.url)!)
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.allHTTPHeaderFields = headers
        
        urlRequest.timeoutInterval = timeoutInterval
        
        urlRequest.httpBody = body
        
        //    if let headers = headers {
        //        urlRequest.headers = headers
        //    }
        
//        if let params = parameters {
//
//            urlRequest = try encoding.encode(urlRequest, with: params)
//
//        }
        
        return urlRequest
        
    }
}
