import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    
    static func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    static func getTimeColor(for seconds: Int) -> Color {
        switch seconds {
        case 0...10:
            return .red
        case 11...30:
            return .orange
        default:
            return .primary
        }
    }
}
