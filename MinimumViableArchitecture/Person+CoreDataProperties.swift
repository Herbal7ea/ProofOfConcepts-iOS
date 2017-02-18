//
//  Person+CoreDataProperties.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/17/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var ahnentafelNumber: Int32
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var firstName: String?
    @NSManaged public var genotypicGender: String?
    @NSManaged public var lastName: String?
    @NSManaged public var children: NSSet
    @NSManaged public var father: Person?
    @NSManaged public var mother: Person?
    @NSManaged public var partners: NSSet
    @NSManaged public var profileImage: Media?
    @NSManaged public var events: NSSet

}

// MARK: Generated accessors for children
extension Person {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Person)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Person)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for partner
extension Person {

    @objc(addPartnerObject:)
    @NSManaged public func addToPartner(_ value: Person)

    @objc(removePartnerObject:)
    @NSManaged public func removeFromPartner(_ value: Person)

    @objc(addPartner:)
    @NSManaged public func addToPartner(_ values: NSSet)

    @objc(removePartner:)
    @NSManaged public func removeFromPartner(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Person {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
