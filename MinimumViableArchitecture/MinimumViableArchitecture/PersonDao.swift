//
//  PersonDao.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation

class EventDao {
    var type: EventType
    var date: Date?
    var info: String?
    var location: LocationDao?
    var targetPerson: PersonDao?
    
    init(type: EventType, date: Date? = nil, info: String? = nil, location: LocationDao? = nil, targetPerson: PersonDao? = nil) {
        self.type = type
        self.date = date
        self.info = info
        self.location = location
        self.targetPerson = targetPerson
    }
}

struct LocationDao {
    var address: String?
    var city: String?
    var country: String?
}

class PersonDao {
    var ahnentafelNumber: Int
    var birthDate: Date?
    var firstName: String?
    var genotypicGender: String?
    var lastName: String?
    
    var children: [PersonDao]
    var events: [EventDao]
    var father: PersonDao?
    var mother: PersonDao?
    var partners: [PersonDao]
    var profileImage: MediaDao?
    
    init(ahnentafelNumber: Int,
         children: [PersonDao],
         events: [EventDao],
         partners: [PersonDao],
         father: PersonDao?,
         mother: PersonDao? = nil,
         birthDate: Date?,
         firstName: String?,
         genotypicGender: String?,
         lastName: String?,
         profileImage: MediaDao? = nil)
    {
        self.ahnentafelNumber = ahnentafelNumber
        self.birthDate = birthDate
        self.firstName = firstName
        self.genotypicGender = genotypicGender
        self.lastName = lastName
        self.children = children
        self.events = events
        self.father = father
        self.mother = mother
        self.partners = partners
        self.profileImage = profileImage
    }

}
