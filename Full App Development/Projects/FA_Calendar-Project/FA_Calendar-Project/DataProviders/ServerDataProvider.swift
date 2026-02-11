//
//  ServerDataProvider.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/6/26.
//
import Foundation

struct ServerDataProvider: DataProvider {
    var user: User? = nil
    enum ServiceError: Error {
        case notLoggedIn
        case loginFailed
        case dataFetchedFailed
        case invalidID
    }
    
    func login(email: String, password: String) async throws -> User {
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/auth/login")
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        let jsonEncoder = JSONEncoder()
        let bodyJSON = try? jsonEncoder.encode(body)
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyJSON
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServiceError.loginFailed
        }
        
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: data)
        return user
    }
    
    
    func getDays() async throws -> [CalendarEntryResponseDTO] {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/calendar/all?cohort=fall2025")
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let days = try decoder.decode([CalendarEntryResponseDTO].self, from: data)
        return days
    }
    
    func getToday() async throws -> CalendarEntryResponseDTO {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/calendar/today?cohort=fall2025")
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let today = try decoder.decode(CalendarEntryResponseDTO.self, from: data)
        return today
    }
    
    func getLessonInfo(id: String) async throws -> LessonOutlineResponseDTO {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/lesson/\(id)")
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let lesson = try decoder.decode(LessonOutlineResponseDTO.self, from: data)
        return lesson
    }
    
    func getDayInfo(id: String) async throws -> CalendarEntryResponseDTO {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/calendar/date/\(id)?cohort=fall2025")
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let today = try decoder.decode(CalendarEntryResponseDTO.self, from: data)
        return today

    }
    
    func getAssignmentInfo(id: String) async throws -> AssignmentResponseDTO {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/assignment/\(id)?includeProgress=true&includeFAQs=true")
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let assignment = try decoder.decode(AssignmentResponseDTO.self, from: data)
        return assignment
    }
    
    func updateProgress(id: String, progress: String) async throws -> AssignmentResponseDTO {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/assignment/progress")
        let body: [String: String] = [
            "assignmentID": id,
            "progress": progress
        ]
        let jsonEncoder = JSONEncoder()
        let bodyJSON = try? jsonEncoder.encode(body)
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyJSON
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
        
        let decoder = JSONDecoder()
        let assignment = try decoder.decode(AssignmentResponseDTO.self, from: data)
        return assignment
    }
    
    func resetProgress(id: String) async throws {
        guard let user = self.user else { throw ServiceError.notLoggedIn }
        let url = URLComponents(string: "https://social-media-app.ryanplitt.com/assignment/progress" )
        let body: [String: String] = [
            "assignmentID": id
        ]
        let jsonEncoder = JSONEncoder()
        let bodyJSON = try? jsonEncoder.encode(body)
        var urlRequest = URLRequest(url: url!.url!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(user.secret)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = bodyJSON
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else { throw ServiceError.dataFetchedFailed }
        }
    }
    
    func postFAQ(question: String, answer: String, assignmentID: String) async throws {
        
    }
}
