import SwiftUI

extension Color {
    static let appPrimary = Color("AccentColor")
    static let appBackground = Color("BackgroundColor")
    static let cardBackground = Color("CardBackground")
}

extension Font {
    static let splashTitle = Font.custom("Helvetica-Bold", size: 48)
    static let timerFont = Font.system(size: 64, weight: .bold, design: .monospaced)
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
