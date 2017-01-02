//
//  Run+CoreDataProperties.swift
//  
//
//  Created by Udit Ajmera on 1/2/17.
//
//

import Foundation
import CoreData


extension Run {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: "Run");
    }

    @NSManaged public var distance: Float
    @NSManaged public var duration: Int16
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var truck_number: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Run {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
