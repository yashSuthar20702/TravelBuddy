//
//  Trip+CoreDataProperties.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-14.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var destination: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var startingLocation: String?
    @NSManaged public var thingsToDo: String?
    @NSManaged public var tripId: UUID?
    @NSManaged public var tripName: String?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension Trip {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expenses)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expenses)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension Trip : Identifiable {

}
