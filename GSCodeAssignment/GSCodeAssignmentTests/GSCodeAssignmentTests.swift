//
//  GSCodeAssignmentTests.swift
//  GSCodeAssignmentTests
//
//  Created by Mohanreddy Batchu on 10/09/22.
//

import XCTest
@testable import GSCodeAssignment

class GSCodeAssignmentTests: XCTestCase {

    let apodViewModel:APODViewModel = APODViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
//        fetchPictureOfDay()
        fetchFavoriteData()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            apodViewModel.getAPODDetails(apodViewModel.getCurrentDate(), viewController: UIViewController())
        }
    }
    
    func fetchPictureOfDay()
    {
        apodViewModel.getAPODDetails(apodViewModel.getCurrentDate(), viewController: UIViewController())
        XCTAssertEqual(apodViewModel.errorMessage, nil)
    }
    
    func fetchFavoriteData()
    {
        let favArray = Utility.fetchAPODModel() ?? []
        XCTAssert(favArray.count > 0, "Favorite available")
    }

    func fetchSearchData()
    {
        let currentDate = apodViewModel.getCurrentDate()
        apodViewModel.getAPODDetails(currentDate, viewController: UIViewController())
        XCTAssertEqual(apodViewModel.errorMessage, nil)
    }
}
