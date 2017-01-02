//
//  User+CoreDataProperties.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import Foundation
import CoreData
 

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var emailId: String?
    @NSManaged public var relationship: UserDetails?

}
