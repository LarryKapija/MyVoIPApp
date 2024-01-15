//
//  UserEntity+Extension.swift
//  MyVoIPApp
//
//  Created by Amaury Caballero on 14/1/24.
//

import CoreData

extension UserEntity {
    @objc dynamic var username: String? {
        return username_
    }
}
