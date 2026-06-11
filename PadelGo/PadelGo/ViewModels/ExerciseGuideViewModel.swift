import Foundation
import SwiftUI
import Combine

class ExerciseGuideViewModel: ObservableObject {
    
    private var dataService = PadelDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedSkill: String = "All"
    
    init() {
        // Sync with dataService changes if needed
        dataService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
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
}
