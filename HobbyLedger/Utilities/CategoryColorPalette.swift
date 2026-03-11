import SwiftUI

enum CategoryColorPalette {
    private static let palette: [Color] = [
        Color(red: 0.84, green: 0.30, blue: 0.23),
        Color(red: 0.11, green: 0.49, blue: 0.79),
        Color(red: 0.13, green: 0.63, blue: 0.47),
        Color(red: 0.90, green: 0.62, blue: 0.12),
        Color(red: 0.76, green: 0.26, blue: 0.51),
        Color(red: 0.33, green: 0.38, blue: 0.43)
    ]

    static func color(for categoryName: String) -> Color {
        let hash = abs(categoryName.hashValue)
        return palette[hash % palette.count]
    }
}
