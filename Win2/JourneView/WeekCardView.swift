import SwiftUI

struct WeekCardView: View {
    let week: WeekItem

    // MARK: - Completed

    let bgGreen = Color(
        red: 0.93,
        green: 0.99,
        blue: 0.96
    )

    let pillGreen = Color(
        red: 0.73,
        green: 0.97,
        blue: 0.82
    )

    let textGreen = Color(
        red: 0.09,
        green: 0.40,
        blue: 0.20
    )

    // MARK: - Active

    let bgBlue = Color(
        red: 0.94,
        green: 0.96,
        blue: 1.0
    )

    let pillBlue = Color(
        red: 0.86,
        green: 0.92,
        blue: 0.99
    )

    let textBlue = Color(
        red: 0.11,
        green: 0.31,
        blue: 0.85
    )

    let dotBlue = Color(
        red: 0.23,
        green: 0.51,
        blue: 0.96
    )

    // MARK: - Locked

    let bgLocked = Color(
        red: 0.93,
        green: 0.93,
        blue: 0.94
    )

    let pillLocked = Color(
        red: 0.86,
        green: 0.86,
        blue: 0.87
    )

    let textLocked = Color(
        red: 0.42,
        green: 0.42,
        blue: 0.44
    )

    let dotLocked = Color(
        red: 0.55,
        green: 0.55,
        blue: 0.57
    )

    var body: some View {

        let isDone = week.isCompleted
        let isLocked = week.isLocked

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(
                    week.title.uppercased()
                )
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundColor(
                    isLocked
                    ? textLocked
                    : isDone
                        ? textGreen
                        : .gray
                )

                Text(
                    isLocked
                    ? "Upcoming"
                    : week.dateRange
                )
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundColor(
                    isLocked
                    ? textLocked
                    : .black
                )
            }

            Spacer()

            HStack(spacing: 6) {

                // -----------------------------------------
                // LOCKED
                // -----------------------------------------

                if isLocked {

                    Circle()
                        .fill(dotLocked)
                        .frame(
                            width: 8,
                            height: 8
                        )

                    Text("Soon")
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )

                }

                // -----------------------------------------
                // COMPLETED
                // -----------------------------------------

                else if isDone {

                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .font(
                        .system(size: 14)
                    )

                    Text("Done")
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )

                }

                // -----------------------------------------
                // ACTIVE
                // -----------------------------------------

                else {

                    Circle()
                        .fill(dotBlue)
                        .frame(
                            width: 8,
                            height: 8
                        )

                    Text("Active")
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )
                }
            }
            .foregroundColor(
                isLocked
                ? textLocked
                : isDone
                    ? textGreen
                    : textBlue
            )
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isLocked
                ? pillLocked
                : isDone
                    ? pillGreen
                    : pillBlue
            )
            .clipShape(
                Capsule()
            )
        }
        .padding(18)
        .background(
            isLocked
            ? bgLocked
            : isDone
                ? bgGreen
                : bgBlue
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
