//
//  ProgressTrackingView.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//
import SwiftUI

struct ProgressTrackingView: View {

    @StateObject private var dataService =
        PadelDataService.shared

    @State var selectedSkill: String = "Serve"

    @State private var tempProgress:
    [String: [String: Double]] = [:]

    var skills: [String] {

        dataService.skills.map { $0.name }
    }

    var currentSkill: PadelSkill? {

        dataService.skills.first {

            $0.name == selectedSkill
        }
    }

    var body: some View {

        NavigationStack {

            VStack {

                Picker(
                    "Skill",
                    selection: $selectedSkill
                ) {

                    ForEach(skills, id: \.self) { skill in
                        Text(skill)
                            .tag(skill)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {

                    VStack(spacing: 16) {

                        Text(currentSkill?.name ?? "")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)

                        // SLIDERS

                        VStack(spacing: 12) {

                            ForEach(
                                currentSkill?.criteria ?? [],
                                id: \.self
                            ) { key in

                                SkillSlider(

                                    title: key,

                                    value: Binding(

                                        get: {

                                            tempProgress[selectedSkill]?[key] ?? 0
                                        },

                                        set: { newValue in

                                            if tempProgress[selectedSkill] == nil {

                                                tempProgress[selectedSkill] = [:]
                                            }

                                            tempProgress[selectedSkill]?[key] = newValue
                                        }
                                    )
                                )
                            }
                        }
                        .padding(.horizontal)


                        Button(action: {

                            dataService.progress =
                                tempProgress

                            FirestoreService.shared
                                .saveProgress(
                                    progress: tempProgress
                                ) {

                                    FirestoreService.shared
                                        .saveProgressHistory(
                                            progress: tempProgress
                                        )

                                    dataService.fetchProgress()
                                    dataService.fetchHistory()
                                }


                            UserDefaults.standard.set(
                                Date().timeIntervalSince1970,
                                forKey:
                                    "lastProgressSaveDate"
                            )

                            print("All progress saved")

                        }) {

                            Text("Save All Progress")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)

                        Text(
                            "Adjust sliders then click Save"
                        )
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Progress Tracking")
            .navigationBarTitleDisplayMode(.inline)

            .onAppear {

                loadCurrentProgress()
            }
        }
    }

    // LOAD CURRENT PROGRESS

    func loadCurrentProgress() {

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {

            for skill in dataService.skills {

                var criteriaValues:
                [String: Double] = [:]

                for criteria in skill.criteria {

                    criteriaValues[criteria] =
                        dataService.progress[
                            skill.name
                        ]?[criteria] ?? 0
                }

                tempProgress[skill.name] =
                    criteriaValues
            }
            
        }
    }
}

