//
//  UserDetails+CoreDataProperties.swift
//  BoschAssignmt
//
//  Created by Udit Ajmera on 12/30/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails");
    }

    @NSManaged public var truck_model: String?
    @NSManaged public var truck_color: String?
    @NSManaged public var truck_number: String?
    @NSManaged public var current_location: String?
    @NSManaged public var destination_location: String?

}
