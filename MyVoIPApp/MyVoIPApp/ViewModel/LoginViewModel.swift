//
//  LoginViewModel.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import Combine
import Firebase
import AgoraRtcKit

class LoginViewModel: ObservableObject {
    private let firebaseService: FirebaseService
    private let userService: UserService
    private let coreDataStack: CoreDataStack

    private var cancellables: Set<AnyCancellable> = []

    init(
        firebaseService: FirebaseService,
        userService: UserService,
        coreDataStack: CoreDataStack
    ) {
        self.firebaseService = firebaseService
        self.userService = userService
        self.coreDataStack = coreDataStack
    }
    
    func loginUser(username: String, completion: @escaping (LoginStatus) -> Void) {
        // Check if the user already exists in Firebase
        firebaseService.fetchUser(username: username, context: coreDataStack.context) { user, error in
            if let user = user, (user.username != nil), (user.userid != nil) {
                self.userService.saveUser(username: user.username!, token: user.userid!)
                completion(.LoginSucceed)
            } else {
                // Register the user in Firebase
                self.firebaseService.registerUser(withUserId: " ", username: username) { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.Failed)
                        } else {
                            // Successfully registered on Firebase
                            // User not found in Firebase, create and save user in CoreData
                            self?.userService.saveUser(username: username)
                            completion(.UserCreated)
                        }
                    }
                }
            }
        }
    }
}

enum LoginStatus {
    case Process
    case UserCreated
    case LoginSucceed
    case Failed
}
