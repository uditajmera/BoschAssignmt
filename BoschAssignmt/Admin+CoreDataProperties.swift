//
//  Admin+CoreDataProperties.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import Foundation
import CoreData


extension Admin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Admin> {
        return NSFetchRequest<Admin>(entityName: "Admin");
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var emailId: String?

}
