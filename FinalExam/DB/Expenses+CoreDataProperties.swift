//
//  Expenses+CoreDataProperties.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-14.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var espenseName: String?
    @NSManaged public var expense: NSDecimalNumber?
    @NSManaged public var expenseId: UUID?
    @NSManaged public var exoenseTotal: NSDecimalNumber?
    @NSManaged public var trip: Trip?

}

extension Expenses : Identifiable {

}
