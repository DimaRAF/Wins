import SwiftUI
import Charts

struct FocusChartCardView: View {

    let weekTitle: String
    let dailyData: [DailyFocus]

    // MARK: - Selection

    @Binding var selectedDay: String?

    // MARK: - Dynamic Axis

    private var maximumMinutes: Int {

        let highestValue =
            dailyData
                .map {
                    max(
                        Int($0.minutes),
                        $0.targetMinutes
                    )
                }
                .max() ?? 0

        return max(
            10,
            Int(
                ceil(
                    Double(highestValue) / 10.0
                )
            ) * 10
        )
    }

    // Exactly 5 intervals
    private var yAxisValues: [Int] {

        let step = max(
            10,
            Int(
                ceil(
                    Double(maximumMinutes) / 5.0
                )
            )
        )

        return stride(
            from: 0,
            through: maximumMinutes,
            by: step
        ).map { $0 }
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

            // MARK: - Legend

            HStack(spacing: 16) {

                // Today
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
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
                            .system(
                                size: 12
                            )
                        )
                        .foregroundColor(.gray)
                }

                // Past days
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            Color(
                                red: 0.54,
                                green: 0.76,
                                blue: 0.93
                            )
                        )
                        .frame(
                            width: 8,
                            height: 8
                        )

                    Text("Past days highlighted")
                        .font(
                            .system(
                                size: 12
                            )
                        )
                        .foregroundColor(.gray)
                }
            }

            // MARK: Chart Container

            ZStack(
                alignment: .topTrailing
            ) {

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
                        .opacity(
                            selectedDay == nil
                            ? 1.0
                            :
                            selectedDay == data.day
                            ? 1.0
                            : 0.45
                        )
                        .cornerRadius(5)
                    }
                }

                // MARK: Chart Configuration

                .chartYScale(
                    domain:
                        0...Double(
                            maximumMinutes
                        )
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

                // MARK: Single Tap On Chart

                .chartOverlay { proxy in

                    GeometryReader { geometry in

                        Rectangle()
                            .fill(
                                Color.clear
                            )
                            .contentShape(
                                Rectangle()
                            )
                            .highPriorityGesture(
                                SpatialTapGesture()
                                    .onEnded { value in

                                        let location =
                                            value.location

                                        let plotFrame =
                                            geometry[
                                                proxy.plotAreaFrame
                                            ]

                                        let x =
                                            location.x
                                            -
                                            plotFrame.origin.x

                                        guard x >= 0,
                                              x <= plotFrame.width
                                        else {
                                            return
                                        }

                                        if let day: String =
                                            proxy.value(
                                                atX: x,
                                                as: String.self
                                            ) {

                                            if dailyData.contains(
                                                where: {
                                                    $0.day == day
                                                }
                                            ) {

                                                selectedDay = day
                                            }
                                        }
                                    }
                            )
                    }
                }

                .frame(
                    height: 180
                )

                // MARK: Popup

                if let selectedData {

                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {

                        Text(
                            "Target: \(selectedData.targetMinutes) min"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(.gray)

                        Text(
                            "Focus: \(Int(selectedData.minutes)) min"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(.black)
                    }
                    .padding(
                        .horizontal,
                        18
                    )
                    .padding(
                        .vertical,
                        14
                    )
                    .background(
                        Color.white
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                    .shadow(
                        color:
                            Color.black.opacity(
                                0.12
                            ),
                        radius: 10,
                        x: 0,
                        y: 4
                    )

                    // Keep popup inside card

                    .padding(
                        .top,
                        8
                    )
                    .padding(
                        .trailing,
                        8
                    )

                    .transition(
                        .opacity
                            .combined(
                                with: .scale(
                                    scale: 0.95
                                )
                            )
                    )
                }
            }
        }

        .padding(16)

        .background(
            Color.white
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )

        .shadow(
            color:
                Color.black.opacity(
                    0.04
                ),
            radius: 8,
            x: 0,
            y: 4
        )

        .padding(.horizontal)
    }
}
