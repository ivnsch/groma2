import SwiftUI

struct Theme {
    static let mainBg = Color(hex: "#ffe135")
    static let mainFg = Color(hex: "#fffbc9")
    static let accent = Color(hex: "#000000")
//    static let tabsBg = Color(hex: "#667218")
//    static let tabsBg = Color(hex: "#ceb180")
//    static let tabsBg = Color(hex: "#cc7722")
//    static let tabsBg = Color(hex: "#d2b55b")
//    static let tabsBg = Color(hex: "#c49102")
//    static let tabsBg = Color(hex: "#000000")
    static let tabsTint = Color(hex: "#ffffff")
    static let tabAccent = Color(hex: "#000000")

}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
