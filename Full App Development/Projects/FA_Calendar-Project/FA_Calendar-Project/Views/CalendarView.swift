//
//  CalendarView.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/10/26.
//
import SwiftUI

struct CalendarView: View {
    @Environment(DataFetcher.self) var dataFetcher
    @State var days: [CalendarEntryResponseDTO]? = nil
    var body: some View {
        NavigationStack {
            if let days {
                List {
                    ForEach(days) { day in
                        NavigationLink(destination: DetailedDayView(day: day)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(day.lessonName ?? "None")
                                        .font(.title.bold())
                                        .padding()
                                    Text(formatISODate(day.date) ?? day.date)
                                        .font(.title3.italic())
                                }
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Text("Fetching days...")
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
        .task {
            do {
                days = try await dataFetcher.dataProvider.getDays()
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
