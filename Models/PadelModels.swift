//
//  PadelModel.swift
//  Padel Go
//
//  Created by student on 29/05/26.
//

import Foundation
import SwiftUI
import Combine

//Skill Model

struct PadelSkill: Identifiable, Codable {

    var id: String
    var name: String
    var criteria: [String]
}

//Exercise Model

struct PadelExercise: Identifiable, Codable {

    var id: String
    var name: String
    var description: String
    var steps: [String]
    var imageIcon: String
    var targetSkill: String
}

//Data Service

class PadelDataService: ObservableObject {

    static let shared = PadelDataService()

    @Published var skills: [PadelSkill] = []

    @Published var exercises: [PadelExercise] = []

    @Published var progress: [String: [String: Double]] = [:]

    init() {

        fetchSkills()

        fetchExercises()

        fetchProgress()
    }

    //FETCH SKILLS

    func fetchSkills() {

        FirestoreService.shared.fetchSkills { skills in

            DispatchQueue.main.async {

                self.skills = skills
            }
        }
    }

    //FETCH EXERCISES

    func fetchExercises() {

        FirestoreService.shared.fetchExercises { exercises in

            DispatchQueue.main.async {

                self.exercises = exercises
            }
        }
    }

    //UPDATE PROGRESS

    func updateProgress(
        skill: String,
        criteria: String,
        value: Double
    ) {

        if progress[skill] == nil {

            progress[skill] = [:]
        }

        progress[skill]?[criteria] = value
    }

    //FETCH USER PROGRESS

    func fetchProgress() {

        FirestoreService.shared.fetchProgress { data in

            DispatchQueue.main.async {

                self.progress = data as? [String: [String: Double]] ?? [:]
            }
        }
    }
}
