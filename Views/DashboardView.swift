//
//  dashboard.swift
//  Padel Go
//
//  Created by student on 29/05/26.
//

import SwiftUI
import Charts

struct DashboardView: View {

    @StateObject private var dataService = PadelDataService.shared

    var body: some View {

        NavigationView {

            ScrollView {

                VStack(spacing: 16) {

                    // HEADER

                    VStack(spacing: 4) {

                        Text("PadelGo")
                            .font(.largeTitle)
                            .bold()

                        Text("Track Your Padel Skills")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)

                    // SKILLS

                    ForEach(dataService.skills) { skill in

                        NavigationLink(
                            destination: ProgressTrackingView(
                                selectedSkill: skill.name
                            )
                        ) {

                            HStack {

                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(skill.name)
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    let completedCount =
                                    dataService.progress[skill.name]?
                                        .values
                                        .filter { $0 > 0 }
                                        .count ?? 0

                                    Text(
                                        "\(completedCount)/\(skill.criteria.count) criteria filled"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    // RECENT ACTIVITY

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack {

                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)

                            Text("Progress tracking enabled")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // CHART

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Last 7 Progress Saves")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart {

                            ForEach(dataService.progressHistory) { item in

                                // GET ALL VALUES FROM ALL SKILLS
                                let allValues =
                                item.progress.values.flatMap { $0.values }

                                let average =
                                allValues.reduce(0, +)
                                / Double(max(allValues.count, 1))

                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Average", average)
                                )
                            }
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}
