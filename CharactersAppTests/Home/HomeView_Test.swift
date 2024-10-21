//
//  HomeView_Test.swift
//  CharactersAppTests
//
//  Created by Esraa Gomaa on 10/21/24.
//

import XCTest
@testable import CharactersApp

final class HomeView_Test: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// [HomeViewModel] -> test default Value of 'isLoading'
    func test_HomeViewModel_default_isLoading() {
        // Given
        let isLoading = false
        
        // When
        let vm = HomeViewModel()
        
        // Then
        XCTAssertEqual(isLoading, vm.isLoading)
    }

    /// [HomeViewModel] -> test default Value of  'pullToRefresh'
    func test_HomeViewModel_default_pullToRefresh() {
        // Given
        let pullToRefresh = false
        
        // When
        let vm = HomeViewModel()
        
        // Then
        XCTAssertEqual(pullToRefresh, vm.pullToRefresh)
    }
}
