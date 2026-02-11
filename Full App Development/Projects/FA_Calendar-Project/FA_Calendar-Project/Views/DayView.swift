    //
    //  DayView.swift
    //  FA_Calendar-Project
    //
    //  Created by Caleb Mace on 2/6/26.
    //
import SwiftUI

struct DayView: View {
    @Environment(DataFetcher.self) var dataFetcher
    @State var day: CalendarEntryResponseDTO? = nil
    var body: some View {
        NavigationStack {
            if let day {
                if day.holiday == true {
                    Text("Today is a holiday!")
                        .font(.largeTitle.bold())
                } else {
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
                            HStack {
                                Text("New Assignments: ")
                                    .italic()
                                Text("\(day.newAssignments.count)")
                                    .bold()
                            }
                            .padding()
                            HStack {
                                Text("Assignments Due: ")
                                    .italic()
                                Text("\(day.assignmentsDue.count)")
                                    .bold()
                            }
                            .padding()
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
                        NavigationLink {
                            DetailedDayView(day: day)
                        } label: {
                            Text("Open day")
                                .frame(width: 300, height: 30)
                        }
                        .padding(.top, 60)
                        .padding()
                        .buttonStyle(.glassProminent)
                    }
                    .padding()
                }
            } else {
                Text("Failed to Fetch Day.")
            }
        }
        .task {
            do {
                try await day = dataFetcher.dataProvider.getToday()
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
        outFormatter.timeZone = TimeZone(secondsFromGMT: 0) // 'Z' means UTC
        outFormatter.dateFormat = "M-d-yyyy" // e.g. 2-10-2026
        
        return outFormatter.string(from: date)
    }
}
