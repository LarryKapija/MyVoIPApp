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
        databaseReference.child(.users).observe(.value) { snapshot in
            var users: [UserEntity] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let userDict = snapshot.value as? [String: Any],
                   let userId = userDict[.userid] as? Int16,
                   let username = userDict[.username] as? String {
                    let user = UserEntity(context: context)
                    user.userid = userId
                    user.username = username
                    users.append(user)
                }
            }

            completion(users)
        }
    }

    func registerUser(username: String, completion: @escaping (Int16?, Error?) -> Void) {
        
        let id = customHash(username)
        let userObject: [String: Any] = [.username: username, .userid: id]
        let userReference = databaseReference.child(.users).child(username)
        
        userReference.updateChildValues(userObject) { error, _ in

            if error != nil {
                completion(nil, error)
                return
            }

            completion(id, nil)
        }
    }


    func updateUserToken(username: String, token: String, completion: @escaping (Error?) -> Void) {
        databaseReference.child(.users).child(username).updateChildValues([String.userid: token]) { error, _ in
            completion(error)
        }
    }
    
    func checkUserExists(username: String, completion: @escaping (Bool) -> Void) {
        databaseReference.child(.users).child(username).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
 
    func fetchUser(username: String, context: NSManagedObjectContext, completion: @escaping (UserEntity?, Error?) -> Void) {
        databaseReference.child(.users).queryOrdered(byChild: .username).queryEqual(toValue: username).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: Any],
                   let userid = value[username] as? Int16 {
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
        databaseReference.child(.users).observeSingleEvent(of: .value, with: { snapshot in
            var users: [UserEntity] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let username = value[.username] as? String,
                   let userid = value[.userid] as? Int16 {
                    
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
    
    private func customHash(_ input: String) -> Int16 {
        let maxInt16Value: UInt16 = 32767
        var hash: UInt16 = 0

        for (index, char) in input.enumerated() {
            
            let charValue = UInt16(char.unicodeScalars.first!.value)
            let contribution = charValue * UInt16(index + 1)

            hash = (hash &* 31 &+ contribution) % maxInt16Value
        }

        return Int16(bitPattern: hash)
    }
}
