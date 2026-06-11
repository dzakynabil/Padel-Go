import Foundation
import SwiftUI
import Combine

class SmartScheduleViewModel: ObservableObject {
    
    private var dataService = PadelDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var completedExercises: Set<String> = []
    
    // Sink to dataService to update view when dataService changes
    init() {
        dataService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    var weakestSkill: String {
        var averages: [String: Double] = [:]
        
        for skill in dataService.skills {
            let values = Array(
                dataService.progress[skill.name]?.values
                ?? Dictionary<String, Double>().values
            )
            
            if values.isEmpty {
                averages[skill.name] = 0
            } else {
                let total = values.reduce(0, +)
                averages[skill.name] = total / Double(values.count)
            }
        }
        
        let sorted = averages.sorted { $0.value < $1.value }
        return sorted.first?.key ?? "Serve"
    }
    
    var recommendedExercises: [PadelExercise] {
        dataService.exercises.filter {
            $0.targetSkill == weakestSkill
        }
    }
    
    func toggleExercise(exercise: PadelExercise) {
        if completedExercises.contains(exercise.id) {
            // UNCHECK: kurangi progress
            completedExercises.remove(exercise.id)
            updateProgress(skill: exercise.targetSkill, increase: false)
        } else {
            // CHECK: tambah progress
            completedExercises.insert(exercise.id)
            updateProgress(skill: exercise.targetSkill, increase: true)
        }
        saveCompletedExercises()
    }
    
    private func updateProgress(skill: String, increase: Bool) {
        let boostAmount: Double = 5.0
        
        guard let skillData = dataService.skills.first(where: { $0.name == skill }) else { return }
        var currentProgress = dataService.progress
        
        if currentProgress[skill] == nil {
            currentProgress[skill] = [:]
        }
        
        for criteria in skillData.criteria {
            let currentValue = currentProgress[skill]?[criteria] ?? 0
            
            if increase {
                currentProgress[skill]?[criteria] = min(currentValue + boostAmount, 100)
            } else {
                currentProgress[skill]?[criteria] = max(currentValue - boostAmount, 0)
            }
        }
        
        // SAVE TO FIRESTORE VIA DATASERVICE
        dataService.saveProgressData(newProgress: currentProgress) {
            // Done
        }
    }
    
    func saveCompletedExercises() {
        let todayKey = todayDateKey()
        UserDefaults.standard.set(Array(completedExercises), forKey: "completedExercises_\(todayKey)")
    }
    
    func loadCompletedExercises() {
        let todayKey = todayDateKey()
        let saved = UserDefaults.standard.stringArray(forKey: "completedExercises_\(todayKey)") ?? []
        completedExercises = Set(saved)
    }
    
    private func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
