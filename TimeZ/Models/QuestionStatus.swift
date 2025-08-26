import Foundation

enum QuestionStatus: String, CaseIterable {
    case pending = "Pending"
    case done = "Done"
    case skipped = "Skipped"
    case timeout = "Timeout"
}
