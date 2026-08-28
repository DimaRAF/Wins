//test
import SwiftUI

// نموذج بيانات الأيام لـ Chart
struct DailyFocus: Identifiable {
    let id = UUID()

    let date: Date
    let day: String

    // Actual Work
    let minutes: Double

    // Target for this day
    let targetMinutes: Int

    let isToday: Bool
}

// نموذج بيانات الرؤى الذكية
struct InsightItem: Identifiable {
    let id = UUID()
    let icon: String // اسم أيقونة SF Symbols
    let text: String
    let theme: InsightTheme
}

// ألوان الثيمات للبطاقات الفرعية
enum InsightTheme {
    case orange, green, yellow, purple
    
    var backgroundColor: Color {
        switch self {
        case .orange: return Color(red: 1.0, green: 0.94, blue: 0.90)
        case .green: return Color(red: 0.91, green: 0.98, blue: 0.93)
        case .yellow: return Color(red: 1.0, green: 0.98, blue: 0.85)
        case .purple: return Color(red: 0.95, green: 0.93, blue: 0.98)
        }
    }
    
    var iconColor: Color {
        switch self {
        case .orange: return Color(red: 0.95, green: 0.45, blue: 0.15)
        case .green: return Color(red: 0.20, green: 0.65, blue: 0.40)
        case .yellow: return Color(red: 0.85, green: 0.65, blue: 0.10)
        case .purple: return Color(red: 0.55, green: 0.35, blue: 0.85)
        }
    }
}

// نموذج الأسبوع
struct WeekItem: Identifiable {
    let id = UUID()
    let title: String
    let dateRange: String
    let weekDateRange: String
    var isCompleted: Bool
    var isLocked: Bool
    let dailyData: [DailyFocus]
    let insights: [InsightItem]
}
