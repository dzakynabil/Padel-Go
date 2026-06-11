import Foundation

struct ProgressHistory: Identifiable, Codable {
    var id: String
    var date: Date
    var progress: [String: [String: Double]]
}
