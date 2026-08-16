//test
import SwiftUI

struct WeekSelectorBarView: View {
    let weeks: [WeekItem]
    @Binding var selectedWeekTitle: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(weeks) { week in
                    WeekPillView(
                        week: week,
                        isSelected: selectedWeekTitle == week.title
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedWeekTitle = week.title
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct WeekPillView: View {
    let week: WeekItem
    let isSelected: Bool
    let action: () -> Void
    
    let appBlue = Color(red: 0.17, green: 0.56, blue: 0.78)
    let checkmarkGreen = Color(red: 0.35, green: 0.76, blue: 0.61)
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if week.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(UIColor.systemGray4))
                        .font(.system(size: 12))
                } else if !isSelected && week.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(checkmarkGreen)
                        .font(.system(size: 14))
                }
                
                Text(week.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(textColor)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(backgroundColor)
            .clipShape(Capsule())
            .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
            .overlay(
                Capsule().stroke(borderColor, lineWidth: 1.5)
            )
        }
        .disabled(week.isLocked)
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if week.isLocked {
            return Color(UIColor.systemGray3)
        }

        if isSelected {
            return .white
        }

        if week.isCompleted {
            return .black
        }

        return appBlue
    }

    private var backgroundColor: Color {
        // Locked weeks should NEVER become blue,
        // even if they are selected programmatically.
        if week.isLocked {
            return Color(UIColor.systemGray6)
        }

        if isSelected {
            return appBlue
        }

        return .white
    }

    private var borderColor: Color {
        if week.isLocked {
            return Color(UIColor.systemGray5)
        }

        return .clear
    }

    private var shadowColor: Color {
        if week.isLocked {
            return .clear
        }

        if isSelected {
            return .clear
        }

        return Color.black.opacity(0.06)
    }
    
}
