//
//  DashboardView.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//

import SwiftUI
import Charts

struct DashboardView: View {

    @StateObject private var dataService =
        PadelDataService.shared
    

    var body: some View {

        NavigationStack {
            
            VStack(spacing: 20) {
            
                VStack(spacing: 4) {

                    Text("PadelGo")
                        .font(.largeTitle)
                        .bold()

                    Text("Last 7 Progress Saves")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                VStack(alignment: .leading, spacing: 12) {

                    Text("Progress History")
                        .font(.headline)
                        .padding(.horizontal)

                    if dataService.progressHistory.isEmpty {

                        VStack(spacing: 10) {

                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.largeTitle)
                                .foregroundColor(.gray)

                            Text("No progress history yet")
                                .foregroundColor(.gray)

                            Text("Save progress to generate chart")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)

                    } else {

                        Chart {

                            ForEach(
                                dataService.progressHistory
                            ) { item in

                                let allValues =
                                item.progress.values.flatMap {
                                    $0.values
                                }

                                let average =
                                allValues.reduce(0, +)
                                / Double(
                                    max(allValues.count, 1)
                                )
                                
                                LineMark(
                                    x: .value(
                                        "Date",
                                        item.date
                                    ),
                                    y: .value(
                                        "Average",
                                        average
                                    )
                                )
                                
                                PointMark(
                                    x: .value(
                                        "Date",
                                        item.date
                                    ),
                                    y: .value(
                                        "Average",
                                        average
                                    )
                                )
                            }
                        }
                        .frame(height: UIDevice.current.userInterfaceIdiom == .pad
                               ? 450
                               : 260)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

#Preview {
    DashboardView()
}
