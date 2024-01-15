//
//  MockFirebaseService.swift
//  MyVoIPAppTests
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
@testable import MyVoIPApp
import CoreData

class MockFirebaseService: FirebaseService {
    var isRegisterUserCalled = false
    var isUpdateUserTokenCalled = false
    var isFetchUsersCalled = false

    override func registerUser(withUserId userId: String, username: String, completion: @escaping (Error?) -> Void) {
        isRegisterUserCalled = true
        completion(nil) // Simulates a successful operation
    }

    override func updateUserToken(userId: String, token: String, completion: @escaping (Error?) -> Void) {
        isUpdateUserTokenCalled = true
        completion(nil) // Simulates a successful operation
    }

    override func fetchUsers(context: NSManagedObjectContext, completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        isFetchUsersCalled = true
        completion(.success([])) // Simulates a successful return of users
    }
}
