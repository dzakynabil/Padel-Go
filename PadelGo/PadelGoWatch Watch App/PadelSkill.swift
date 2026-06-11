//
//  PadelSkill.swift
//  PadelGo
//
//  Created by Macbook on 11/06/26.
//


import Foundation


struct PadelSkill: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let criteria: [String]
    
    // For Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PadelSkill, rhs: PadelSkill) -> Bool {
        lhs.id == rhs.id
    }
}


extension PadelSkill {
    static let allSkills: [PadelSkill] = [
        PadelSkill(name: "Serve", criteria: ["Accuracy", "Placement", "Consistency","Variation", "Control"]),
        PadelSkill(name: "Volley", criteria: ["Reflexes", "Control", "Consistency","Placement", "Timing"]),
        PadelSkill(name: "Forehand & Backahand", criteria: ["Power", "Accuracy", "Consistency", "Footwork", "Adaptability"]),
        PadelSkill(name: "Lob", criteria: ["Height", "Accuracy", "Depth","Consistency","Strategic Use"]),
        PadelSkill(name: "Smash", criteria: ["Power", "Accuracy", "Timing", "Recovery", "Variation"]),    ]
}


struct SkillProgress: Codable {
    var values: [String: Double] // criteria name: value (0-100)
    
    init() {
        self.values = [:]
    }
    
    init(criteria: [String]) {
        self.values = [:]
        for criterion in criteria {
            values[criterion] = 50.0 // Default value
        }
    }
}
