//
//  PersonTranslator.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation
import CoreData



class LocationTranslator {
    func translate(location: Location?) -> LocationDao? {
        guard let location = location else { return nil }
        
        let locationDao = LocationDao(address: location.address, city: location.city, country: location.country)
        return locationDao
    }
    func translate(dao: LocationDao?, context: NSManagedObjectContext) -> Location? {
        guard let dao = dao else { return nil }
        
        let location = Location(context: context)
            location.address = dao.address
            location.country = dao.country
            location.city    = dao.city
        
        return location
    }
}

class EventTranslator {
    let locationTranslator = LocationTranslator()
    let personTranslator = PersonTranslator()
    
    func translate(event: Event?) -> EventDao? {
        guard let event = event else { return nil }
        
        let date = event.date as Date?
        
        let location     = locationTranslator.translate(location: event.location)
        let targetPerson = personTranslator.translate(person: event.targetPerson)
        
        let eventDao = EventDao(type: event.type, date: date, info: event.info, location: location, targetPerson: targetPerson)
        
        return eventDao
    }
    
    func translate(dao: EventDao?, context: NSManagedObjectContext) -> Event? {
        guard let dao = dao else { return nil }
        
        let date = dao.date as NSDate?
        
        let location     = locationTranslator.translate(dao: dao.location, context: context)
        let targetPerson = personTranslator.translate(dao: dao.targetPerson, context: context)
        
        let event = Event(context: context)
            event.type = dao.type
            event.date = date
            event.info = dao.info
            event.location = location
            event.targetPerson = targetPerson
        
        return event
    }
}

class PersonTranslator {
    var mediaTranslator = MediaTranslator()
    var eventTranslator = EventTranslator()
    
    func translate(person: Person?) -> PersonDao? {
        guard let person = person else { return nil }
        
        let birthDate = person.birthDate as! Date
        let profileImage = mediaTranslator.translate(media: person.profileImage)
        let children = person.children.flatMap { translate(person: ($0 as? Person)) }
        let partners = person.partners.flatMap { translate(person: ($0 as? Person)) }
        let events =  person.events.flatMap { eventTranslator.translate(event: $0 as? Event) }
        let father = translate(person: person.father)
        let mother = translate(person: person.mother)
        
        let dao = PersonDao(ahnentafelNumber: Int(person.ahnentafelNumber), children: children, events: events, partners: partners, father: father, mother: mother, birthDate: birthDate, firstName: person.firstName, genotypicGender: person.genotypicGender, lastName: person.lastName, profileImage: profileImage)
        
        return dao
    }

    func translate(dao: PersonDao?, context: NSManagedObjectContext) -> Person? {
        guard let dao = dao else { return nil }
        
        let birthDate = dao.birthDate as NSDate?
        let profileImage = MediaTranslator().translate(dao: dao.profileImage, context: context)
        let children = dao.children.flatMap { translate(dao: $0, context: context) }
        let partners = dao.partners.flatMap { translate(dao: $0, context: context) }
        let events = dao.events.flatMap { eventTranslator.translate(dao: $0, context: context) }
        let childrenSet = Set(children) as NSSet
        let partnersSet = Set(partners) as NSSet
        let eventsSet   = Set(events)   as NSSet
        let father = translate(dao: dao.father, context: context)
        let mother = translate(dao: dao.mother, context: context)
        
        //need to account for Updates to the Data Base
        let person = Person(context: context)
            person.ahnentafelNumber = Int32(dao.ahnentafelNumber)
            person.lastName = dao.lastName
            person.firstName = dao.firstName
            person.birthDate = birthDate
            person.genotypicGender = dao.genotypicGender
            person.profileImage = profileImage
            person.children = childrenSet
            person.partners = partnersSet
            person.events = eventsSet
            person.father = father
            person.mother = mother
        
        return person
    }
    

    
//    func translate(dao: MediaDao, context: NSManagedObjectContext) -> Media {
//        let media = Media(context: context)
//        media.id = dao.id
//        media.url = dao.url
//        
//        return media
//    }
//
    
}
