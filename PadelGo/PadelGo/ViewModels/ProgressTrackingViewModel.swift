import Foundation
import SwiftUI
import Combine

class ProgressTrackingViewModel: ObservableObject {
    
    private var dataService = PadelDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var tempProgress: [String: [String: Double]] = [:]
    @Published var selectedSkill: String = "Serve"
    
    init() {
        // Sync with dataService changes if needed
        dataService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    var skills: [String] {
        dataService.skills.map { $0.name }
    }
    
    var currentSkill: PadelSkill? {
        dataService.skills.first { $0.name == selectedSkill }
    }
    
    func getProgressValue(for key: String) -> Double {
        tempProgress[selectedSkill]?[key] ?? 0
    }
    
    func setProgressValue(for key: String, value: Double) {
        if tempProgress[selectedSkill] == nil {
            tempProgress[selectedSkill] = [:]
        }
        tempProgress[selectedSkill]?[key] = value
    }
    
    func saveAllProgress() {
        dataService.saveProgressData(newProgress: tempProgress) {
            UserDefaults.standard.set(
                Date().timeIntervalSince1970,
                forKey: "lastProgressSaveDate"
            )
            print("All progress saved")
        }
    }
    
    func loadCurrentProgress() {
        // Add slight delay to ensure dataService has fetched from Firestore
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for skill in self.dataService.skills {
                var criteriaValues: [String: Double] = [:]
                for criteria in skill.criteria {
                    criteriaValues[criteria] = self.dataService.progress[skill.name]?[criteria] ?? 0
                }
                self.tempProgress[skill.name] = criteriaValues
            }
        }
    }
}
