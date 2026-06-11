import Foundation

struct ProgressHistory: Identifiable, Codable {
    var id: String
    var date: Date
    var progress: [String: [String: Double]]
    
    var averageProgress: Double {
        let allValues = progress.values.flatMap { $0.values }
        guard !allValues.isEmpty else { return 0 }
        let total = allValues.reduce(0, +)
        return total / Double(allValues.count)
    }
}
