import SwiftUI

struct WeekCardView: View {
    let week: WeekItem

    // Green colors - Done
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

    // Blue colors - Active
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

    var body: some View {

        let isDone =
            week.isCompleted

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
                .foregroundColor(.gray)

                Text(
                    week.dateRange
                )
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundColor(.black)

                // REAL DATE
                Text(
                    week.weekDateRange
                )
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
                .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 6) {

                if isDone {

                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .font(
                        .system(
                            size: 14
                        )
                    )

                } else {

                    Circle()
                        .fill(dotBlue)
                        .frame(
                            width: 8,
                            height: 8
                        )
                }

                Text(
                    isDone
                    ? "Done"
                    : "Active"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
            }
            .foregroundColor(
                isDone
                ? textGreen
                : textBlue
            )
            .padding(
                .horizontal,
                14
            )
            .padding(
                .vertical,
                8
            )
            .background(
                isDone
                ? pillGreen
                : pillBlue
            )
            .clipShape(
                Capsule()
            )
        }
        .padding(18)
        .background(
            isDone
            ? bgGreen
            : bgBlue
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
