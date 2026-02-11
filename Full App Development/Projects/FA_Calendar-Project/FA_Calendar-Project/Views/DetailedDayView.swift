    //
    //  DetailedDayView.swift
    //  FA_Calendar-Project
    //
    //  Created by Caleb Mace on 2/10/26.
    //

import SwiftUI

struct DetailedDayView: View {
    @Environment(DataFetcher.self) var dataFetcher
    @State var day: CalendarEntryResponseDTO
    @State var foundData: Bool = false
    init(day: CalendarEntryResponseDTO) {
        self.day = day
    }
    var body: some View {
        NavigationStack {
            if foundData {
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                Text("Date: ")
                                    .font(.title)
                                    .italic()
                                Text(formatISODate(day.date) ?? day.date)
                                    .font(.title)
                                    .bold()
                            }
                            .padding()
                            Text(day.lessonName ?? "None")
                                .multilineTextAlignment(.center)
                                .font(.largeTitle.bold())
                                .padding()
                        }
                        Spacer()
                        VStack {
                            if let objective = day.mainObjective {
                                HStack {
                                    Text("Main Objective: ")
                                        .italic()
                                    Text(day.mainObjective == "" ? "None" : objective)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }
                            if let reading = day.readingDue {
                                HStack {
                                    Text("Reading due: ")
                                        .italic()
                                    Text(reading == "" ? "None" : reading)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }
                            Spacer()
                            if day.newAssignments.isEmpty {
                                Text("There Are No New Assignments Today.")
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                            } else {
                                ForEach(day.newAssignments) { assignment in
                                    NavigationLink(destination: AssignmentView(assignment: assignment)) {
                                        Text(assignment.name)
                                            .font(.title2.bold())
                                            .padding()
                                        Text("Due on: \(assignment.dueOn ?? "Unknown")")
                                            .font(.title3.bold())
                                            .padding()
                                    }
                                    .buttonStyle(.glass)
                                }
                            }
                            if day.assignmentsDue.isEmpty {
                                Text("There Are No Assignments Due Today.")
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                            } else {
                                ForEach(day.assignmentsDue) { assignment in
                                    NavigationLink(destination: AssignmentView(assignment: assignment)) {
                                        Text(assignment.name)
                                            .font(.title2.bold())
                                            .padding()
                                        Text("Due on: \(assignment.dueOn ?? "Unknown")")
                                            .font(.title3.bold())
                                            .padding()
                                    }
                                    .buttonStyle(.glass)
                                }
                            }
                            HStack {
                                Text("Code Challenge: ")
                                    .multilineTextAlignment(.center)
                                    .italic()
                                Text(day.dailyCodeChallengeName ?? "None")
                                    .multilineTextAlignment(.center)
                                    .bold()
                            }
                            .padding()
                            HStack {
                                Text("Word of the Day: ")
                                    .italic()
                                    .multilineTextAlignment(.center)
                                Text(day.wordOfTheDay ?? "None")
                                    .bold()
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                        Spacer()
                    }
                    .padding()
                }
            } else {
                Text("Fetching day...")
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .task {
            do {
                try await day = dataFetcher.dataProvider.getDayInfo(id: formatISODate(day.date) ?? "")
                foundData = true
            } catch {
                print(error)
            }
        }
    }
    func formatISODate(_ isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
            // Add .withFractionalSeconds if your input sometimes includes milliseconds
        isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        outFormatter.dateFormat = "yyyy-M-d"
        
        return outFormatter.string(from: date)
    }
}
