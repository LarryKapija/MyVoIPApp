//
//  FirebaseService.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import Foundation

import Foundation
import FirebaseDatabase
import CoreData

class FirebaseService {
    private let databaseReference: DatabaseReference

    init() {
        databaseReference = Database.database().reference()
    }
    
    func observeUserList( context: NSManagedObjectContext, completion: @escaping ([UserEntity]) -> Void) {
        databaseReference.child("users").observe(.value) { snapshot in
            var users: [UserEntity] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let userDict = snapshot.value as? [String: Any],
                   let userId = userDict["userid"] as? String,
                   let username = userDict["username"] as? String {
                    let user = UserEntity(context: context)
                    user.userid = userId
                    user.username = username
                    users.append(user)
                }
            }

            completion(users)
        }
    }

    func registerUser(withUserId userId: String, username: String, completion: @escaping (Error?) -> Void) {
        let userObject: [String: Any] = ["username": username, "userid": userId]
        let userReference = databaseReference.child("users").child(username)
        
        userReference.updateChildValues(userObject) { error, _ in
            completion(error)
        }
    }


    func updateUserToken(username: String, token: String, completion: @escaping (Error?) -> Void) {
        databaseReference.child("users").child(username).updateChildValues(["userid": token]) { error, _ in
            completion(error)
        }
    }
    
    func checkUserExists(username: String, completion: @escaping (Bool) -> Void) {
        databaseReference.child("users").child(username).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func setUserId(username: String, token: String, completion: @escaping (Error?) -> Void) {
        checkUserExists(username: username) { exists in
            guard exists else {
                completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                return
            }
            let updates: [String: Any] = ["token": token]
            self.databaseReference.child("users").child(username).updateChildValues(updates, withCompletionBlock: { error, _ in
                completion(error)
            })
        }
    }
    
    func fetchUser(username: String, context: NSManagedObjectContext, completion: @escaping (UserEntity?, Error?) -> Void) {
        databaseReference.child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: Any],
                   let userid = value[username] as? String {
                    let user = UserEntity(context: context)
                    user.userid = userid
                    user.username = username
                    completion(user, nil)
                } else {
                    completion(nil, NSError(domain: "Error parsing user data", code: 0, userInfo: nil))
                }
            } else {
                completion(nil, nil) // Usuario no encontrado
            }
        }) { error in
            completion(nil, error)
        }
    }
    
    func fetchUsers(context: NSManagedObjectContext, completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        databaseReference.child("users").observeSingleEvent(of: .value, with: { snapshot in
            var users: [UserEntity] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let username = value["username"] as? String,
                   let userid = value["userid"] as? String {
                    
                    let user = UserEntity(context: context)
                    user.userid = userid
                    user.username = username
                    users.append(user)
                }
            }
            
            completion(.success(users))
        }) { error in
            completion(.failure(error))
        }
    }
}
