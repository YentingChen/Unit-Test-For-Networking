//
//  APIServiceProtocol.swift
//  UnitTestForNetworking
//
//  Created by Yenting Chen on 2022/1/9.
//

import Foundation

protocol APIServiceProtocol {
    
    associatedtype RequestDataType
    
    associatedtype ResponseDataType
    
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    
    func parseResponse(from data: Data) throws -> ResponseDataType
    
}
