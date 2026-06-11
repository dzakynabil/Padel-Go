//
//  SmartScheduleView.swift
//  PadelGo
//
//  Created by ~ Macbook ~ on 02/06/26.
//

import SwiftUI

struct SmartScheduleView: View {

    @StateObject private var viewModel = SmartScheduleViewModel()

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
                        "Today's focus: \(viewModel.weakestSkill)"
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

                    if viewModel.recommendedExercises.isEmpty {

                        Text(
                            "No exercises available"
                        )
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    } else {

                        ForEach(
                            viewModel.recommendedExercises
                        ) { exercise in

                            HStack {

                                // CHECKLIST BUTTON

                                Button(action: {

                                    viewModel.toggleExercise(
                                        exercise: exercise
                                    )

                                }) {

                                    Image(
                                        systemName:
                                            viewModel.completedExercises
                                            .contains(
                                                exercise.id
                                            )
                                            ? "checkmark.circle.fill"
                                            : "circle"
                                    )
                                    .font(.title2)
                                    .foregroundColor(
                                        viewModel.completedExercises
                                            .contains(
                                                exercise.id
                                            )
                                        ? .green
                                        : .gray
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(exercise.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .strikethrough(
                                            viewModel.completedExercises
                                                .contains(
                                                    exercise.id
                                                )
                                        )

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
                                viewModel.completedExercises
                                    .contains(exercise.id)
                                ? Color.green.opacity(0.1)
                                : Color(.systemGray6)
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
            .onAppear {

                viewModel.loadCompletedExercises()
            }

        }
    }

}

#Preview {
    SmartScheduleView()
}
