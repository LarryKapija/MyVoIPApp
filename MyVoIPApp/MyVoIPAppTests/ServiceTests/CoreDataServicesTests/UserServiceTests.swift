//
//  UserServiceTests.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import XCTest
@testable import MyVoIPApp
import CoreData

class UserServiceTests: XCTestCase {

    var coreDataTestStack: CoreDataTestStack!
    var userService: UserService!

    override func setUp() {
        super.setUp()
        coreDataTestStack = CoreDataTestStack()
        userService = UserService(context: coreDataTestStack.context)
    }

    override func tearDown() {
        super.tearDown()
        coreDataTestStack = nil
        userService = nil
    }

    func testCreateUser() {
        let userID = "testUser123"
        let username = "TestUser"
        userService.createUser(withUserID: userID, username: username)

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let results = try? coreDataTestStack.context.fetch(fetchRequest)

        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.userid, userID)
        XCTAssertEqual(results?.first?.username, username)
    }

    func testFetchUser() {
        let userID = "fetchUser123"
        let username = "FetchUser"
        let user = UserEntity(context: coreDataTestStack.context)
        user.userid = userID
        user.username = username
        try? coreDataTestStack.context.save()

        let fetchedUser = userService.fetchUser(withUserID: userID)
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.userid, userID)
        XCTAssertEqual(fetchedUser?.username, username)
    }

    // Add more tests for other CRUD operations and edge cases as needed
}
