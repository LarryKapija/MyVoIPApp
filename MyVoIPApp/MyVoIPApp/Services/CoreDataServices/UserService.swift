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

    func createUser(withUserID userID: String, username: String) {
        let user = UserEntity(context: context)
        user.userid = userID
        user.username = username
        CoreDataStack.shared.saveContext()
    }

    func fetchUser(withUserID userID: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userid == %@", userID)

        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }

    // Add more CRUD operations as needed
}
