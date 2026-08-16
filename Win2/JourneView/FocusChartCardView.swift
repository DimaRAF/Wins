import SwiftUI
import Charts

struct FocusChartCardView: View {

    let weekTitle: String
    let dailyData: [DailyFocus]

    @State private var selectedDay: String? = nil

    // MARK: - Dynamic Axis

    private var maximumMinutes: Int {

        let highestValue =
            dailyData
                .map {
                    Int($0.minutes)
                }
                .max() ?? 0

        if highestValue <= 0 {
            return 10
        }

        let magnitude =
            pow(
                10.0,
                floor(
                    log10(
                        Double(highestValue)
                    )
                )
            )

        let normalized =
            Double(highestValue) /
            magnitude

        let niceNumber: Double

        if normalized <= 1 {
            niceNumber = 1
        } else if normalized <= 2 {
            niceNumber = 2
        } else if normalized <= 5 {
            niceNumber = 5
        } else {
            niceNumber = 10
        }

        return Int(
            niceNumber * magnitude
        )
    }

    // MARK: - Five Axis Values

    private var yAxisValues: [Int] {

        guard maximumMinutes > 0 else {
            return [0, 1, 2, 3, 4]
        }

        let step =
            Double(maximumMinutes) / 4.0

        return (0...4).map { index in
            Int(
                round(
                    Double(index) * step
                )
            )
        }
    }

    // MARK: - Selected Data

    private var selectedData: DailyFocus? {

        guard let selectedDay else {
            return nil
        }

        return dailyData.first {
            $0.day == selectedDay
        }
    }

    // MARK: - Body

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            // MARK: Header

            HStack {

                Text("Minutes per Day")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.black)

                Spacer()

                Text(weekTitle)
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundColor(.gray)
            }

            // MARK: Legend

            HStack(spacing: 6) {

                RoundedRectangle(
                    cornerRadius: 2
                )
                .fill(
                    Color(
                        red: 0.17,
                        green: 0.56,
                        blue: 0.78
                    )
                )
                .frame(
                    width: 8,
                    height: 8
                )

                Text("Today highlighted")
                    .font(
                        .system(size: 12)
                    )
                    .foregroundColor(.gray)
            }

            // MARK: Chart

            Chart {

                ForEach(dailyData) { data in

                    BarMark(
                        x: .value(
                            "Day",
                            data.day
                        ),
                        y: .value(
                            "Minutes",
                            data.minutes
                        )
                    )
                    .foregroundStyle(
                        data.isToday
                        ? Color(
                            red: 0.17,
                            green: 0.56,
                            blue: 0.78
                        )
                        : Color(
                            red: 0.54,
                            green: 0.76,
                            blue: 0.93
                        )
                    )
                    .cornerRadius(5)
                }
            }

            // MARK: Y Axis

            .chartYScale(
                domain:
                    0...Double(maximumMinutes)
            )

            .chartYAxis {

                AxisMarks(
                    position: .leading,
                    values: yAxisValues
                ) {

                    AxisGridLine(
                        stroke: StrokeStyle(
                            lineWidth: 0.8
                        )
                    )
                    .foregroundStyle(
                        Color(
                            UIColor.systemGray5
                        )
                    )

                    AxisValueLabel()
                        .font(
                            .system(
                                size: 10
                            )
                        )
                        .foregroundStyle(
                            Color.gray
                        )
                }
            }

            // MARK: X Axis

            .chartXAxis {

                AxisMarks(
                    position: .bottom
                ) {

                    AxisValueLabel()
                        .font(
                            .system(
                                size: 10,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color.gray
                        )
                }
            }

            // MARK: Day Selection

            .chartXSelection(
                value: $selectedDay
            )

            .frame(height: 180)

            // MARK: Selected Day Info

            if let selectedData {

                HStack {

                    Spacer()

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text(
                            "Target: \(selectedData.targetMinutes) min"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(
                            .gray
                        )

                        Text(
                            "Focus: \(Int(selectedData.minutes)) min"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(
                            .black
                        )
                    }
                    .padding(
                        .horizontal,
                        22
                    )
                    .padding(
                        .vertical,
                        18
                    )
                    .background(
                        Color.white
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24
                        )
                    )
                    .shadow(
                        color:
                            Color.black.opacity(
                                0.12
                            ),
                        radius: 12,
                        x: 0,
                        y: 5
                    )
                }
                .padding(.top, -150)
                .padding(.bottom, 20)
                .transition(
                    .opacity.combined(
                        with:
                            .scale(
                                scale: 0.95
                            )
                    )
                )
            }
        }

        .padding(16)

        .background(
            Color.white
        )

        .cornerRadius(20)

        .shadow(
            color:
                Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 4
        )

        .padding(.horizontal)

        .animation(
            .easeInOut(duration: 0.2),
            value: selectedDay
        )
    }
}
