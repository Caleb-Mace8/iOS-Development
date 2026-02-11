//
//  AssignmentView.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/11/26.
//
import SwiftUI

struct AssignmentView: View {
    @Environment(DataFetcher.self) var dataFetcher
    @State var assignment: AssignmentResponseDTO
    @State var isPresenting: Bool = false
    @State var selectedProgress: Progress = .notStarted
    var body: some View {
        NavigationStack {
            Text(assignment.name)
                .font(.title.bold())
                .padding()
            Text(assignment.assignmentType.capitalized)
                .font(.title3.italic())
                .padding()
            Divider()
            if let progress = assignment.userProgress {
                if progress == "notStarted" {
                    Text("Progress: Not Started")
                        .font(.title3.bold())
                } else if progress == "inProgress" {
                    Text("Progress: In Progress")
                        .font(.title3.bold())
                } else {
                    Text("Progress: Complete")
                        .font(.title3.bold())
                }
            }
            Picker("Progress", selection: $selectedProgress) {
                ForEach(Progress.allCases) { progress in
                    switch progress {
                        case .notStarted:
                            Text("Not Started")
                        case .inProgress:
                            Text("In Progress")
                        case .complete:
                            Text("Complete")
                    }
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .padding(.bottom, 30)
            HStack {
                Button {
                    Task {
                        do {
                            assignment = try await dataFetcher.dataProvider.updateProgress(id: assignment.id, progress: assignment.userProgress ?? "notStarted")
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Submit Progress")
                }
                .buttonStyle(.glassProminent)
                .disabled(assignment.userProgress == nil)
                Button {
                    Task {
                        do {
                            try await dataFetcher.dataProvider.resetProgress(id: assignment.id)
                            assignment.userProgress = nil
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Reset Progress")
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
                .disabled(assignment.userProgress == nil)
            }
            HStack {
                Text("FAQ's")
                    .font(.title2.bold())
                Spacer()
                Button {
                    isPresenting = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)
            }
            .padding()
            .padding(.bottom, 50)
            if assignment.faqs.isEmpty {
                Text("There are no FAQ's at This Time.")
                    .bold()
            } else {
                List {
                    ForEach(assignment.faqs) { faq in
                        VStack {
                            HStack {
                                if let question = faq.question {
                                    Text("Question:")
                                        .font(.title3.bold())
                                    Text(question)
                                        .font(.title3.italic())
                                }
                            }
                            .padding()
                            HStack {
                                if let answer = faq.answer {
                                    Text("Answer:")
                                        .font(.title3.bold())
                                    Text(answer)
                                        .font(.title3.italic())
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .task {
            do {
                assignment = try await dataFetcher.dataProvider.getAssignmentInfo(id: assignment.id)
                if let progress = assignment.userProgress {
                    switch progress {
                        case "inProgress":
                            selectedProgress = .inProgress
                        case "complete":
                            selectedProgress = .complete
                        default:
                            selectedProgress = .notStarted
                    }
                }
            } catch {
                print(error)
            }
        }
        .onChange(of: selectedProgress) { _, progress in
            switch progress {
                case .notStarted:
                    assignment.userProgress = "notStarted"
                case .inProgress:
                    assignment.userProgress = "inProgress"
                case .complete:
                    assignment.userProgress = "complete"
            }
        }
    }
}
