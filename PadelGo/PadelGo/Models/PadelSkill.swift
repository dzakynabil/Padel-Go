//
//  PadelSkill.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//

import Foundation
import SwiftUI
import Combine

// SKILL MODEL

struct PadelSkill: Identifiable, Codable {

    var id: String
    var name: String
    var criteria: [String]
}

// EXERCISE MODEL

struct PadelExercise: Identifiable, Codable {

    var id: String
    var name: String
    var description: String
    var steps: [String]
    var imageIcon: String
    var targetSkill: String
}

// HISTORY MODEL

struct ProgressHistory: Identifiable, Codable {

    var id: String
    var date: Date
    var progress: [String: [String: Double]]
}

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


}
