//
//  ExamResult+CoreDataProperties.swift
//  TUSubasa
//
//  Created by Alperen Kaya on 26.11.2025.
//
//

public import Foundation
public import CoreData


public typealias ExamResultCoreDataPropertiesSet = NSSet

extension ExamResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExamResult> {
        return NSFetchRequest<ExamResult>(entityName: "ExamResult")
    }

    @NSManaged public var date: Date?
    @NSManaged public var totalCount: Int16
    @NSManaged public var correctCount: Int16
    @NSManaged public var score: Int16
    @NSManaged public var id: UUID?

}

extension ExamResult : Identifiable {

}
