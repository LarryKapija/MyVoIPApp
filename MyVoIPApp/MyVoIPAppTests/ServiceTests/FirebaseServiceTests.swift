//
//  FirebaseServiceTests.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import XCTest
import CoreData
@testable import MyVoIPApp

class FirebaseServiceTests: XCTestCase {
//    var firebaseService: FirebaseService!
//    var mockFirebaseService: MockFirebaseService!
//    var context: NSManagedObjectContext!
//
//    override func setUp() {
//        super.setUp()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        context = appDelegate.persistentContainer.viewContext
//        mockFirebaseService = MockFirebaseService()
//        firebaseService = FirebaseService()
//    }
//
//    override func tearDown() {
//        firebaseService = nil
//        mockFirebaseService = nil
//        super.tearDown()
//    }
//
//    func testRegisterUser() {
//        let expectation = self.expectation(description: "RegisterUser")
//        mockFirebaseService.registerUser(withUserId: "testId", username: "testUser") { error in
//            XCTAssertNil(error)
//            XCTAssertTrue(self.mockFirebaseService.isRegisterUserCalled)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//
//    func testUpdateUserToken() {
//        let expectation = self.expectation(description: "UpdateUserToken")
//        mockFirebaseService.updateUserToken(userId: "testId", token: "testToken") { error in
//            XCTAssertNil(error)
//            XCTAssertTrue(self.mockFirebaseService.isUpdateUserTokenCalled)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//
//    func testFetchUsers() {
//        let expectation = self.expectation(description: "FetchUsers")
//        mockFirebaseService.fetchUsers(context: context) { result in
//            switch result {
//            case .success(let users):
//                XCTAssertTrue(users.isEmpty)
//            case .failure(let error):
//                XCTFail("Error fetching users: \(error)")
//            }
//            XCTAssertTrue(self.mockFirebaseService.isFetchUsersCalled)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//    }
}
