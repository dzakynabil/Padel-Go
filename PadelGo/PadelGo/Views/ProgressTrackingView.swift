//
//  ProgressTrackingView.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//
import SwiftUI

struct ProgressTrackingView: View {

    @StateObject private var viewModel = ProgressTrackingViewModel()

    var body: some View {

        NavigationStack {

            VStack {

                Picker(
                    "Skill",
                    selection: $viewModel.selectedSkill
                ) {

                    ForEach(viewModel.skills, id: \.self) { skill in
                        Text(skill)
                            .tag(skill)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {

                    VStack(spacing: 16) {

                        Text(viewModel.currentSkill?.name ?? "")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)

                        // SLIDERS

                        VStack(spacing: 12) {

                            ForEach(
                                viewModel.currentSkill?.criteria ?? [],
                                id: \.self
                            ) { key in

                                SkillSlider(

                                    title: key,

                                    value: Binding(

                                        get: {
                                            viewModel.getProgressValue(for: key)
                                        },

                                        set: { newValue in
                                            viewModel.setProgressValue(for: key, value: newValue)
                                        }
                                    )
                                )
                            }
                        }
                        .padding(.horizontal)


                        Button(action: {
                            viewModel.saveAllProgress()
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

                viewModel.loadCurrentProgress()
            }
        }
    }
}
