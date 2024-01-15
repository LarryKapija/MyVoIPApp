//
//  UserListViewModel.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation
import Combine
import CoreData

class UserListViewModel: ObservableObject {
    private let firebaseService: FirebaseService
    private let userService: UserService
    private let coreDataStack: CoreDataStack
    private var userName: String?
    
    @Published var users: [UserEntity?] = []

    private var cancellables: Set<AnyCancellable> = []

    init(
        firebaseService: FirebaseService,
        userService: UserService,
        coreDataStack: CoreDataStack
    ) {
        self.firebaseService = firebaseService
        self.userService = userService
        self.coreDataStack = coreDataStack

        // Observe the list of users in real-time from Firebase
        firebaseService.observeUserList(context: coreDataStack.context) { [weak self] usersFromFirebase in
            DispatchQueue.main.async {
                self?.filterUsers(usersFromFirebase)
            }
        }
        
        // Configure the observation of the user list in CoreData
        setupUserListObservation()
    }
    
    func refreshUserList() {
        let context = coreDataStack.context
        // Fetch the list of users from Firebase (excluding the current user)
        firebaseService.fetchUsers(context: context) { [weak self] result in
            switch result {
            case .success(let users):
                // Get the userID of the current user
                self?.userName = self?.userService.fetchUser()?.username
                // Update the users list
                DispatchQueue.main.async {
                    self?.filterUsers(users)
                }
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    
    private func filterUsers(_ users: [UserEntity?]) {
        self.users = users.filter { $0?.username != userName}
    }
    
    func fetchUserName() -> String? {
        return userService.fetchUser()?.username
    }

    func callUser(_ user: UserEntity) {
        // Navigate to the call screen and initiate the call using agoraService
        // Implement this part once the call screen is created
    }

    private func setupUserListObservation() {
        $users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
}
