//
//  SmartScheduleView.swift
//  PadelGo
//
//  Created by ~ Macbook ~ on 02/06/26.
//

import SwiftUI

struct SmartScheduleView: View {

    @StateObject private var dataService =
        PadelDataService.shared

    // WEAKEST SKILL

    var weakestSkill: String {

        var averages:
        [String: Double] = [:]

        for skill in dataService.skills {

            let values = Array(
                dataService.progress[
                    skill.name
                ]?.values
                ?? Dictionary<String, Double>().values
            )

            if values.isEmpty {

                averages[skill.name] = 0

            } else {

                let total =
                    values.reduce(0, +)

                averages[skill.name] =
                    total / Double(values.count)
            }
        }

        let sorted =
            averages.sorted {
                $0.value < $1.value
            }

        return sorted.first?.key ?? "Serve"
    }

    var recommendedExercises:
    [PadelExercise] {

        dataService.exercises.filter {

            $0.targetSkill == weakestSkill
        }
    }

    var body: some View {

        NavigationStack {

            VStack {

                VStack(spacing: 8) {

                    Image(
                        systemName:
                            "calendar.badge.clock"
                    )
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                    Text(
                        "Smart Training Schedule"
                    )
                    .font(.headline)

                    Text(
                        "Today's focus: \(weakestSkill)"
                    )
                    .font(.subheadline)
                    .foregroundColor(.blue)

                    Text(
                        "Exercises are recommended based on your weakest skill progress"
                    )
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color.blue.opacity(0.1)
                )
                .cornerRadius(15)
                .padding(.horizontal)


                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {

                    Text("📅 Today's Training")
                        .font(.headline)
                        .padding(.horizontal)

                    if recommendedExercises.isEmpty {

                        Text(
                            "No exercises available"
                        )
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    } else {

                        ForEach(
                            recommendedExercises
                        ) { exercise in

                            HStack {

                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(exercise.name)
                                        .font(.body)
                                        .fontWeight(.medium)

                                    Text(
                                        exercise.targetSkill
                                    )
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                }

                                Spacer()

                                // connect ke punya dzaky  exercise
                                NavigationLink(
                                    destination:
                                        PadelExerciseDetailView(
                                            exercise:
                                                exercise
                                        )
                                ) {

                                    Image(
                                        systemName:
                                            "info.circle"
                                    )
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(
                                Color(.systemGray6)
                            )
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)

                Spacer()
            }
            .navigationTitle("Smart Schedule")

        }
    }

}

#Preview {
    SmartScheduleView()
}
