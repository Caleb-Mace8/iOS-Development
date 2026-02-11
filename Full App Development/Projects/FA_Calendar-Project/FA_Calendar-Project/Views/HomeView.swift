//
//  HomeView.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/6/26.
//

import SwiftUI

struct HomeView: View {
    @State var dataFetcher: DataFetcher = DataFetcher()
    var body: some View {
        NavigationStack {
            if dataFetcher.dataProvider.user != nil {
                TabView {
                    Tab("Today", systemImage: "calendar.day.timeline.left") {
                        DayView()
                    }
                    Tab("Calendar", systemImage: "calendar") {
                        CalendarView()
                    }
                }
            } else {
                SignInView()
            }
        }
        .environment(dataFetcher)
    }
}
