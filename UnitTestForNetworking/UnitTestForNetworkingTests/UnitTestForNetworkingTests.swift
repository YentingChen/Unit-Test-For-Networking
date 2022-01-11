//
//  UnitTestForNetworkingTests.swift
//  UnitTestForNetworkingTests
//
//  Created by Yenting Chen on 2022/1/9.
//

import XCTest
@testable import UnitTestForNetworking

class UnitTestForNetworkingTests: XCTestCase {

    func testGetWeatherURLRequest() throws {
        
        let weatherService = WeatherService()
        
        let request = GetWeatherRequest(queryCity: "london", apiKey: "63859ddfa319a759545f3cdc562ebc61")
        
        let urlRequest =  try weatherService.makeRequest(from: request)
        
        XCTAssertEqual(urlRequest.httpMethod, "GET" )

        XCTAssertEqual(urlRequest.url?.scheme, "https")

        XCTAssertEqual(urlRequest.url?.host, "api.openweathermap.org")
        
        XCTAssertEqual(urlRequest.url?.path, "/data/2.5")
        
        XCTAssertEqual(urlRequest.url?.query, "appid=63859ddfa319a759545f3cdc562ebc61&q=london")

    }
    
    func testParsingResponse() throws {
        
        let weatherService = WeatherService()
        
        let jsonData = "{\"coord\":{\"lon\":-0.1257,\"lat\":51.5085},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"base\":\"stations\",\"main\":{\"temp\":280,\"feels_like\":280,\"temp_min\":277.97,\"temp_max\":281.54,\"pressure\":1020,\"humidity\":90},\"visibility\":10000,\"wind\":{\"speed\":1.03,\"deg\":0},\"rain\":{\"1h\":0.21},\"clouds\":{\"all\":100},\"dt\":1641819843,\"sys\":{\"type\":2,\"id\":2019646,\"country\":\"GB\",\"sunrise\":1641801781,\"sunset\":1641831148},\"timezone\":0,\"id\":2643743,\"name\":\"London\",\"cod\":200}".data(using: .utf8)!
        
        let response = try weatherService.parseResponse(from: jsonData)
        
        XCTAssertEqual(response.name, "London")
        
    }
    
    func testMockLoaderSuccess() {
        
        let weatherService = WeatherService()

        let request = GetWeatherRequest(queryCity: "london", apiKey: "63859ddfa319a759545f3cdc562ebc61")

        let mockJSONData = "{\"coord\":{\"lon\":-0.1257,\"lat\":51.5085},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"base\":\"stations\",\"main\":{\"temp\":280,\"feels_like\":280,\"temp_min\":277.97,\"temp_max\":281.54,\"pressure\":1020,\"humidity\":90},\"visibility\":10000,\"wind\":{\"speed\":1.03,\"deg\":0},\"rain\":{\"1h\":0.21},\"clouds\":{\"all\":100},\"dt\":1641819843,\"sys\":{\"type\":2,\"id\":2019646,\"country\":\"GB\",\"sunrise\":1641801781,\"sunset\":1641831148},\"timezone\":0,\"id\":2643743,\"name\":\"London\",\"cod\":200}".data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            
            XCTAssertEqual(request.url?.query, "appid=63859ddfa319a759545f3cdc562ebc61&q=london")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!

            return (response, mockJSONData)

        }
        
        var mockLoader: APIRequestLoader<WeatherService>?
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: configuration)
        
        mockLoader = APIRequestLoader(apiService: weatherService, urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        
        mockLoader?.loadAPIRequest(requestData: request, completionHandler: {  (weather, error) in
            
            XCTAssertEqual(weather?.name, "London")

            expectation.fulfill()
            
        })

        wait(for: [expectation], timeout: 1)
    }
}
