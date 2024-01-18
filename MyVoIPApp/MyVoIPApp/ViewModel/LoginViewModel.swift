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
        
        self.userService.saveUser(username: username, userid: 0)
        completion(.UserCreated)
        
        // MARK: Legacy logic
        // Check if the user already exists in Firebase
//        firebaseService.fetchUser(username: username, context: coreDataStack.context) { user, error in
//            if let user = user, (user.username != nil) {
//                self.userService.saveUser(username: user.username!, userid: user.userid)
//                completion(.LoginSucceed)
//            } else {
                

//                // Register the user in Firebase
//                self.firebaseService.registerUser(username: username) { [weak self] id, error in
//                    DispatchQueue.main.async {
//                        if (error != nil) {
//                            completion(.Failed)
//                        } else {
//                            // Successfully registered on Firebase
//                            // User not found in Firebase, create and save user in CoreData
//                            self?.userService.saveUser(username: username, userid: Int16(id!))
//                            completion(.UserCreated)
//                        }
//                    }
//                }
            
        
    }
}

enum LoginStatus {
    case Process
    case UserCreated
    case LoginSucceed
    case Failed
}
