//
//  GetWeatherRequest.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/10.
//

import Foundation
import UIKit

struct GetWeatherRequest: BaseRequestProtocol {
    
    var host: String {
        
        return "api.openweathermap.org"
    }
    
    var scheme: String {
        
        return "https"
    }
    
    var path: String {
        
        return "/data/2.5"
    }
    
    var queryCity: String
    
    var apiKey: String
    
    var queryItems: [URLQueryItem]? {
        
        return [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "q", value: queryCity)
        ]
        
    }
   
    var headers: [String : String]?
    
    var body: Data?
    
    var method: HTTPMethod = .get
    
    var timeoutInterval: TimeInterval = TimeInterval(30)
    
    init(queryCity: String, apiKey: String) {
        self.queryCity = queryCity
        self.apiKey =  apiKey
    }
    
}
