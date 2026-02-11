//
//  Models.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/6/26.
//
import Foundation

enum Progress: String, Codable, CaseIterable, Identifiable {
    case notStarted
    case inProgress
    case complete
    
    var id: Self { self }
}

struct CalendarEntryResponseDTO: Identifiable, Codable {
    var id: String
    var date: String
    var holiday: Bool
    var dayID: String?
    var lessonName: String?
    var lessonID: String?
    var mainObjective: String?
    var readingDue: String?
    var assignmentsDue: [AssignmentResponseDTO]
    var newAssignments: [AssignmentResponseDTO]
    var dailyCodeChallengeName: String?
    var wordOfTheDay: String?
}

struct ScheduleItem: Codable {
    var id: String
    var startTime: Time
    var endTime: Time
    var task: String
}

struct Time: Codable {
    var hour: Int
    var minute: Int
}

struct LessonOutlineResponseDTO: Identifiable, Codable {
    var id: String
    var name: String
    var objectives: [String]
    var schedule: [ScheduleItem]
    var body: String?
    var additionalResources: String
}

struct AssignmentResponseDTO: Identifiable, Codable {
    var id: String
    var name: String
    var assignmentType: String
    var assignedOn: String?
    var dueOn: String?
    var userProgress: String?
    var faqs: [FAQResponseDTO]
}

struct FAQResponseDTO: Identifiable, Codable {
    var id: String?
    var assignmentID: String?
    var lessonID: String?
    var question: String?
    var answer: String?
    var lastEditedOn: String?
    var lastEditedBy: String?
}

struct User: Codable, Hashable {
    var email: String
    var lastName: String
    var userUUID: String
    var firstName: String
    var userName: String
    var secret: String
}

protocol DataProvider {
    func getDays() async throws -> [CalendarEntryResponseDTO]
    func getToday() async throws -> CalendarEntryResponseDTO
    func getLessonInfo(id: String) async throws -> LessonOutlineResponseDTO
    func getDayInfo(id: String) async throws -> CalendarEntryResponseDTO
    func getAssignmentInfo(id: String) async throws -> AssignmentResponseDTO
    func updateProgress(id: String, progress: String) async throws -> AssignmentResponseDTO
    func resetProgress(id: String) async throws
    func postFAQ(question: String, answer: String, assignmentID: String) async throws
}
