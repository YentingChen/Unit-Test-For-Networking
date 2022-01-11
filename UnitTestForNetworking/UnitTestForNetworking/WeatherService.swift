//
//  WeatherService.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/10.
//

import Foundation

class WeatherService: APIServiceProtocol {
    
    typealias RequestDataType = GetWeatherRequest
    
    typealias ResponseDataType = Weather
    
    func makeRequest(from data: GetWeatherRequest) throws -> URLRequest {
        return try data.asURLRequest()
    }
    
    func parseResponse(from data: Data) throws -> Weather {
        
        return try JSONDecoder().decode(Weather.self, from: data)
        
    }
    
}
