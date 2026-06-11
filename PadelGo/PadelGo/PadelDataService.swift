//
//  PadelDataService.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 11/06/26.
//

import Foundation
import SwiftUI
import Combine

// DATA SERVICE

class PadelDataService: ObservableObject {
    static let shared = PadelDataService()

    @Published var skills: [PadelSkill] = []

    @Published var exercises: [PadelExercise] = []

    @Published var progress:
    [String: [String: Double]] = [:]

    @Published var progressHistory:
    [ProgressHistory] = []

    init() {
        fetchSkills()
        fetchExercises()
        fetchProgress()
        fetchHistory()
    }
    
    func fetchSkills() {

        FirestoreService.shared.fetchSkills { skills in

            DispatchQueue.main.async {

                self.skills = skills
            }
        }
    }

    // FETCH EXERCISES

    func fetchExercises() {

        FirestoreService.shared.fetchExercises { exercises in

            DispatchQueue.main.async {

                self.exercises = exercises
            }
        }
    }

    // FETCH PROGRESS

    func fetchProgress() {

        FirestoreService.shared.fetchProgress { data in

            DispatchQueue.main.async {

                self.progress = data
            }
        }
    }

    // FETCH HISTORY

    func fetchHistory() {

        FirestoreService.shared.fetchLast7History { history in

            DispatchQueue.main.async {

                self.progressHistory = history
            }
        }
    }


}
