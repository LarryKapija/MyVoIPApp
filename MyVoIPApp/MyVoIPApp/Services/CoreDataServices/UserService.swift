//
//  UserService.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import CoreData

class UserService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func saveUser(username: String, token: String = "") {
        let userEntity = UserEntity(context: context)
        userEntity.username = username
        userEntity.userid = token

        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func updateUserID(username: String, userid: String) {
        let userEntity = UserEntity(context: context)
        userEntity.username = username
        userEntity.userid = userid

        do {
            try context.save()
        } catch {
            print("Failed to save userid: \(error)")
        }
    }
    
    func fetchUser() -> UserEntity? {
         let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
         do {
             let results = try context.fetch(request)
             return results.first
         } catch {
             print("Error fetching user: \(error)")
             return nil
         }
     }

    func fetchUser(withUserName username: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
}
