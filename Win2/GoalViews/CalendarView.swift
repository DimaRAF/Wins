import SwiftUI

struct CalendarDay: Identifiable {
    let date: Date

    var id: Date {
        date
    }
}

struct CalendarView: View {

    private let calendar = Calendar.current

    @State private var selectedDate =
        Calendar.current.startOfDay(for: Date())

    var body: some View {
        TimelineView(
            .periodic(
                from: .now,
                by: 60
            )
        ) { context in

            VStack(alignment: .leading, spacing: 20) {
                header(currentDate: context.date)

                weekCard(currentDate: context.date)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    }

    private func header(
        currentDate: Date
    ) -> some View {

        VStack(alignment: .leading, spacing: 2) {
            Text(greeting(for: currentDate))
                .font(.body)
                .foregroundStyle(.secondary)

            Text(
                selectedDate.formatted(
                    .dateTime
                        .weekday(.wide)
                        .month(.wide)
                        .day()
                )
            )
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }
    }

    private func weekCard(
        currentDate: Date
    ) -> some View {

        HStack(spacing: 0) {
            ForEach(weekDays(for: currentDate)) { day in
                dayButton(
                    for: day,
                    currentDate: currentDate
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(8)
        .background {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(Color("CardBackground"))
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                Color("CardBorder"),
                lineWidth: 1
            )
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    private func dayButton(
        for day: CalendarDay,
        currentDate: Date
    ) -> some View {

        let today = calendar.startOfDay(
            for: currentDate
        )

        let isSelected = calendar.isDate(
            day.date,
            inSameDayAs: selectedDate
        )

        let isToday = calendar.isDate(
            day.date,
            inSameDayAs: today
        )

        let isFuture = day.date > today

        return Button {
            guard !isFuture else {
                return
            }

            selectedDate = day.date
        } label: {
            VStack(spacing: 4) {
                Text(
                    day.date.formatted(
                        .dateTime
                            .weekday(.abbreviated)
                    )
                )
                .font(.caption)
                .fontWeight(.medium)

                Text(
                    day.date.formatted(
                        .dateTime.day()
                    )
                )
                .font(.title3)
                .fontWeight(.semibold)
            }
            .foregroundStyle(
                textColor(
                    isSelected: isSelected,
                    isToday: isToday,
                    isFuture: isFuture
                )
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                    .fill(Color("PrimaryBlue"))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isFuture)
       
       
    }

    private func weekDays(
        for currentDate: Date
    ) -> [CalendarDay] {

        let today = calendar.startOfDay(
            for: currentDate
        )

        guard let weekInterval = calendar.dateInterval(
            of: .weekOfYear,
            for: today
        ) else {
            return []
        }

        return (0..<7).compactMap { dayOffset in
            guard let date = calendar.date(
                byAdding: .day,
                value: dayOffset,
                to: weekInterval.start
            ) else {
                return nil
            }

            return CalendarDay(
                date: calendar.startOfDay(
                    for: date
                )
            )
        }
    }

    private func textColor(
        isSelected: Bool,
        isToday: Bool,
        isFuture: Bool
    ) -> Color {

        if isSelected {
            return .white
        }

    
        if isToday {
            return Color("PrimaryBlue")
        }

        if isFuture {
            return .secondary.opacity(0.55)
        }

        return .primary
    }

    private func greeting(
        for currentDate: Date
    ) -> String {

        let hour = calendar.component(
            .hour,
            from: currentDate
        )

        switch hour {
        case 5..<12:
            return "Good morning"

        case 12..<17:
            return "Good afternoon"

        default:
            return "Good evening"
        }
    }
}

#Preview {
    CalendarView()
        .padding(20)
        .background(Color("AppBackground"))
}
