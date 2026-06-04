//
//  ExerciseGuideView.swift
//  PadelGo
//
//  Created by Macbook on 29/05/26.
//

import SwiftUI

struct ExerciseGuideView: View {
    
    @StateObject private var dataService = PadelDataService.shared
    @State private var selectedSkill = "All"
    
    var skills: [String] {

        ["All"] + dataService.skills.map { $0.name }
    }
    
    var filteredExercises: [PadelExercise] {
        if selectedSkill == "All" {
            return dataService.exercises
        } else {
            return dataService.exercises.filter { $0.targetSkill == selectedSkill }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(skills, id: \.self) { skill in
                            Button(action: {
                                selectedSkill = skill
                            }) {
                                Text(skill)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedSkill == skill ? Color.blue : Color(.systemGray5))
                                    .foregroundColor(selectedSkill == skill ? .white : .black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                
                List(filteredExercises) { exercise in
                    NavigationLink(destination: PadelExerciseDetailView(exercise: exercise)) {
                        HStack {
                            Image(exercise.imageIcon)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.headline)
                                Text(exercise.targetSkill)
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Training Guide")
        }
    }
}

// MARK: - Exercise Detail View (Hanya SATU deklarasi)
struct PadelExerciseDetailView: View {
    let exercise: PadelExercise
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(exercise.imageIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(16)
                    .padding(.horizontal)
                
                Text(exercise.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Image(systemName: "target")
                    Text("Skill: \(exercise.targetSkill)")
                        .font(.caption)
                        .bold()
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(8)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("DESCRIPTION")
                        .font(.headline)
                    Text(exercise.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("INSTRUCTIONS")
                        .font(.headline)
                    
                    ForEach(Array(exercise.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.blue)
                                .clipShape(Circle())
                            
                            Text(step)
                                .font(.body)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 TIPS")
                        .font(.headline)
                    Text("• Warm up before training")
                    Text("• Focus on proper form")
                    Text("• Practice consistently")
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ExerciseGuideView()
}
