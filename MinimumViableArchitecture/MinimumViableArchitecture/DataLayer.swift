//
//  DataLayer.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import Foundation
import CoreData

class DataLayer {

    static var shared = DataLayer()
    var people = [Int: Person]()
    
    static func initialize() {
        //Initialize all data dependencies //usually done through injection of some kind
        CoreDataStack.initialize()
        RealmStack.initialize()
        SharedPreferencesStack.initialize()
        
        let _ = DataLayer.shared
    }
    
    
    
    fileprivate let numberOfPeopleCreated = 150_000
    fileprivate let pageSize = 100
    
    var mainContext = CoreDataStack.shared.mainContext

    init() {
//        setupCoreData()
        
//        let people = loadPeople()
//        
//        for person in people {
//            print("\(person.firstName!) \(person.lastName!) ::: Born \(person.birthDate!)")
//        }
    }
    
    func loadPeopleDaos(fromPageNumber: UInt = 0, numberOfPagesToLoad: UInt = 1) -> [PersonDao] {
        let people = loadPeople(fromPageNumber: fromPageNumber, numberOfPagesToLoad: numberOfPagesToLoad)
        var peopleDaos = [PersonDao]()
        
        printTimeElapsedWhenRunningCode(title: "Converting to DAOs") {
            let translator = PersonTranslator()
            peopleDaos = people.flatMap { translator.translate(person: $0) }
        }
        
        return peopleDaos
    }
}

extension DataLayer {
    
    fileprivate func createPerson(for ahnentafelNumber: Int) -> Person {
        let firstName = "Person \(ahnentafelNumber)"
        let lastName  = "Bot"
        let fullName = "\(firstName) \(lastName)"
        
        
        let media = Media(context: mainContext)
            media.url = URLGenerator.shared.urlStringFor(text: fullName)
        
        let person = Person(context: mainContext)
            person.firstName = firstName
            person.lastName  = lastName
            person.ahnentafelNumber = Int32(ahnentafelNumber)
            person.birthDate = Date(timeIntervalSinceNow: TimeInterval(ahnentafelNumber * Int.secondsInADay)) as NSDate
            person.genotypicGender = ahnentafelNumber.isEven ? "M" : "F"
            person.profileImage = media

        attachEvents(to: person)
        
        return person
    }
    
    fileprivate func attachEvents(to person: Person) {
        let ahnentafelNumber = Int(person.ahnentafelNumber)
        let numberOfYears = TimeInterval(ahnentafelNumber * Int.secondsInAYear)
        
        let capital = capitalsOfTheWorld[ahnentafelNumber]
        
        let location = Location(context: mainContext)
            location.address = "\(ahnentafelNumber) Portabello Road"
            location.country = capital.country
            location.city    = capital.city

        let nextLocation = Location(context: mainContext)
            nextLocation.address = "\(ahnentafelNumber) Secret Location"
            nextLocation.country = capital.country
            nextLocation.city    = capital.city

        
        let birth = Event(context: mainContext)
            birth.date = Date(timeIntervalSinceNow: numberOfYears) as NSDate
            birth.location = location
            birth.type = .birth
        
        let death = Event(context: mainContext)
            death.date = Date(timeIntervalSinceNow: numberOfYears + 100) as NSDate
            death.location = location
            birth.type = .death
        
        var marriage: Event? = nil
        if person.partners.isNotEmpty {
            marriage = Event(context: mainContext)
            marriage?.date = Date(timeIntervalSinceNow: numberOfYears + 100) as NSDate
            marriage?.location = location
            marriage?.targetPerson = person.partners.allObjects.first as? Person
            marriage?.type = .marriage
        }
        
        var divorce: Event? = nil
        if person.partners.isNotEmpty && person.ahnentafelNumber.isEven { //50% of marriages in US end in divorce
            divorce = Event(context: mainContext)
            divorce?.date = Date(timeIntervalSinceNow: numberOfYears + 100) as NSDate
            divorce?.location = location
            divorce?.targetPerson = person.partners.allObjects.first as? Person
            divorce?.type = .divorce
        }
        
        let child = Event(context: mainContext)
            child.date = Date(timeIntervalSinceNow: numberOfYears + 100) as NSDate
            child.location = location
            child.targetPerson = person.children.allObjects.first as? Person
            child.type = .child
        
        let move = Event(context: mainContext)
            move.date = Date(timeIntervalSinceNow: numberOfYears + 100) as NSDate
            move.location = nextLocation
        
        let general = Event(context: mainContext)
            general.date = Date(timeIntervalSinceNow: numberOfYears + 24) as NSDate
            general.info = "University Graduation"
        
        let events = [birth, death, marriage, divorce, child, move, general].flatMap{ $0 }
        
        person.events.addingObjects(from: events)
    }
    
    fileprivate func setRelatives() {
        people.values.forEach {
            setupFamily(for: $0)
            setupPartners(for: $0)
        }
    }
    
    fileprivate func setupFamily(for child: Person) {
        let ahn = Int(child.ahnentafelNumber)
        let fathersIndex = ahn * 2
        let mothersIndex = fathersIndex + 1
        
        if let father = people[fathersIndex] {
            child.father = father
            father.children.adding(child)
        }
        
        if let mother = people[mothersIndex] {
            child.mother = mother
            mother.children.adding(child)
        }
    }
    
    fileprivate func setupPartners(for person: Person) {
        let ahn = Int(person.ahnentafelNumber)
        let partnerIndex = ahn + 1
        
        guard let partner = people[partnerIndex], ahn > 1, ahn.isEven else { return } //working from the male's perspective because math is easier
        
        person.partners.adding(partner)
        partner.partners.adding(person)
    }
}

extension DataLayer {
    fileprivate func clearOldResults() {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try! CoreDataStack.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: mainContext)
        
        fetchRequest = NSFetchRequest(entityName: "Media")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try! CoreDataStack.shared.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: mainContext)
        
        mainContext.reset()
    }
    
    
    fileprivate func setupCoreData() {
        
        //reset the database
        clearOldResults()
        
        people = [:]
        
        for i in 1 ... numberOfPeopleCreated {
            people[i] = createPerson(for: i)
        }
        
        setRelatives()
        
        try! mainContext.save()
    }
    
    fileprivate func loadPeople(fromPageNumber: UInt, numberOfPagesToLoad: UInt, context: NSManagedObjectContext? = nil) -> [Person] {
        
        let sort = NSSortDescriptor(key:"id", ascending: true)
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [sort]
        
        let offset = pageSize * Int(fromPageNumber)
        let fetchLimit = pageSize * Int(numberOfPagesToLoad)
        fetchRequest.fetchLimit  = fetchLimit
        fetchRequest.fetchOffset = offset
        
        print("fetching: \(fetchLimit) recoreds")
        
        let currentContext = context ?? mainContext
        var persons = [Person]()
        
        printTimeElapsedWhenRunningCode(title: "Loading Core Data") {
            persons = try! currentContext.fetch(fetchRequest)
        }
        
        
        return persons
    }
}
