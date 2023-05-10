//
//  ChatAppTests.swift
//  ChatAppTests
//
//  Created by Станислава on 10.05.2023.
//

import XCTest
@testable import ChatApp

class ImageServiceTests: XCTestCase {
    
    var imageService: ImageService!
    var mockNetworkService: MockNetworkService!
    
    let apiKey = "testApiKey"
    let baseURLString = "https://testbaseurl.com/"
    let perPage = 20
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        imageService = ImageService(
            apiKey: apiKey,
            baseURLString: baseURLString,
            perPage: perPage,
            networkService: mockNetworkService
        )
    }
    
    override func tearDown() {
        mockNetworkService = nil
        imageService = nil
        super.tearDown()
    }
    
    func testLoadImages() {
        let expectedURL = URL(
            string: "\(baseURLString)?key=\(apiKey)&q=yellow+flowers&image_type=photo&pretty=true&image_type=photo&pretty=true&per_page=\(perPage)"
        )!
        
        imageService.loadImages { (_) in }
        
        XCTAssertEqual(mockNetworkService.invokedSendRequestParameters?.url, expectedURL)
        XCTAssertTrue(mockNetworkService.invokedSendRequest)
    }
    
    func testLoadImageData() {
        let expectedURLString = "https://testimageurl.com/test.jpg"
        
        imageService.loadImageData(from: expectedURLString) { (_) in }
        
        XCTAssertEqual(mockNetworkService.invokedLoadImageDataParameters?.urlString, expectedURLString)
        XCTAssertTrue(mockNetworkService.invokedLoadImageData)
    }
}
