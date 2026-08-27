import SwiftUI

struct WeekCardView: View {

    let week: WeekItem

    // MARK: - Done Colors

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

    // MARK: - Active Colors

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

    // MARK: - Locked / Upcoming Colors

    let bgGray = Color(
        UIColor.systemGray6
    )

    let pillGray = Color(
        UIColor.systemGray5
    )

    let textGray = Color(
        UIColor.systemGray
    )

    let dotGray = Color(
        UIColor.systemGray
    )

    var body: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 3
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
                    week.isLocked
                    ? textGray
                    : .gray
                )

                Text(
                    week.dateRange
                )
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundColor(
                    week.isLocked
                    ? textGray
                    : .black
                )

                // Real dynamic date
                Text(
                    week.weekDateRange
                )
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
                .foregroundColor(
                    week.isLocked
                    ? textGray
                    : .gray
                )
            }

            Spacer()

            // MARK: - Status

            HStack(spacing: 6) {

                if week.isCompleted {

                    // DONE
                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .font(
                        .system(
                            size: 14
                        )
                    )

                    Text("Done")
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )

                } else if week.isLocked {

                    // UPCOMING / SOON
                    Circle()
                        .fill(dotGray)
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

                } else {

                    // ACTIVE
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

            .foregroundColor(statusTextColor)

            .padding(
                .horizontal,
                14
            )

            .padding(
                .vertical,
                8
            )

            .background(
                statusBackgroundColor
            )

            .clipShape(
                Capsule()
            )
        }

        .padding(18)

        .background(
            cardBackgroundColor
        )

        .cornerRadius(20)

        .padding(.horizontal)
    }

    // MARK: - Status Text Color

    private var statusTextColor: Color {

        if week.isCompleted {
            return textGreen
        }

        if week.isLocked {
            return textGray
        }

        return textBlue
    }

    // MARK: - Status Background

    private var statusBackgroundColor: Color {

        if week.isCompleted {
            return pillGreen
        }

        if week.isLocked {
            return pillGray
        }

        return pillBlue
    }

    // MARK: - Card Background

    private var cardBackgroundColor: Color {

        if week.isCompleted {
            return bgGreen
        }

        if week.isLocked {
            return bgGray
        }

        return bgBlue
    }
}
