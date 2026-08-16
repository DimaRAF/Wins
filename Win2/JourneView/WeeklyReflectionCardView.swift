import SwiftUI

struct WeeklyReflectionCardView: View {

    let insights: [InsightItem]

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            // MARK: - Header

            HStack(
                alignment: .center,
                spacing: 12
            ) {

                Image(systemName: "star")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )
                    .foregroundColor(.black)

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text("Personalized Insights")
                        .font(
                            .system(
                                size: 18,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.black)

                    Text("Based on this week's data")
                        .font(
                            .system(
                                size: 12,
                                weight: .medium
                            )
                        )
                        .foregroundColor(.gray)
                }
            }

            // MARK: - Insights

            VStack(spacing: 8) {

                ForEach(insights) { insight in

                    HStack(
                        alignment: .top,
                        spacing: 10
                    ) {

                        // Insight Icon

                        Image(
                            systemName:
                                insight.icon
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(
                            insight.theme.iconColor
                        )
                        .frame(
                            width: 28,
                            height: 28
                        )
                        .background(
                            Color.white
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 8
                            )
                        )
                        .shadow(
                            color:
                                Color.black.opacity(
                                    0.04
                                ),
                            radius: 2,
                            x: 0,
                            y: 1
                        )

                        // Insight Text

                        Text(insight.text)
                            .font(
                                .system(
                                    size: 12,
                                    weight: .medium
                                )
                            )
                            .foregroundColor(.black)
                            .multilineTextAlignment(
                                .leading
                            )
                            .lineLimit(nil)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .layoutPriority(1)
                    }
                    .padding(
                        .horizontal,
                        10
                    )
                    .padding(
                        .vertical,
                        12
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        insight.theme.backgroundColor
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
                }
            }
        }

        .padding(16)

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

        .background(
            Color(
                red: 0.94,
                green: 0.96,
                blue: 1.0
            )
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )

        .shadow(
            color:
                Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 4
        )

        .padding(.horizontal)
    }
}
