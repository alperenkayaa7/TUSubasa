//
//  Question+CoreDataProperties.swift
//  TUSubasa
//
//  Created by Alperen Kaya on 30.11.2025.
//
//

public import Foundation
public import CoreData


public typealias QuestionCoreDataPropertiesSet = NSSet

extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var correctOption: String?
    @NSManaged public var difficulty: Int16
    @NSManaged public var explanation: String?
    @NSManaged public var feedbackStatus: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var isCorrect: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isSolved: Bool
    @NSManaged public var optionA: String?
    @NSManaged public var optionB: String?
    @NSManaged public var optionC: String?
    @NSManaged public var optionD: String?
    @NSManaged public var optionE: String?
    @NSManaged public var questionID: Int32
    @NSManaged public var reportReason: String?
    @NSManaged public var subject: String?
    @NSManaged public var text: String?
    @NSManaged public var userNote: String?
    @NSManaged public var wrongCount: Int16

}

extension Question : Identifiable {

}
