import SwiftUI

/// warm terracotta and paprika with a saffron accent
enum Theme {
    static let primary = Color(red: 0.651, green: 0.216, blue: 0.114)
    static let accent = Color(red: 0.910, green: 0.639, blue: 0.239)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
