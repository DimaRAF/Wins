import SwiftUI

struct ProgressCardView: View {
    @State private var completedMinutes = 90
    @State private var isShowingTimePicker = false

    private let targetMinutes = 120

    private var progress: Double {
        guard targetMinutes > 0 else { return 0 }

        return min(
            Double(completedMinutes) / Double(targetMinutes),
            1
        )
    }

    private var remainingMinutes: Int {
        max(targetMinutes - completedMinutes, 0)
    }

    var body: some View {
        VStack(spacing: 14) {
            topSection

            Divider()

            goalSection
        }
        .padding(18)
        .frame(maxWidth: .infinity)
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
        .animation(
            .easeInOut(duration: 0.25),
            value: completedMinutes
        )
    }

    private var topSection: some View {
        HStack(alignment: .center, spacing: 12) {
            progressRing

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Today’s focus goal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    editProgressButton
                }

                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 4
                ) {
                    Text(durationText(completedMinutes))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text("/ \(durationText(targetMinutes))")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 8) {
                    ProgressView(value: progress)
                        .tint(Color("PrimaryBlue"))

                    Text("\(durationText(remainingMinutes)) left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize()
                }
            }
        }
    }

    private var editProgressButton: some View {
        Button {
            isShowingTimePicker = true
        } label: {
            Label(
                "Edit Progress",
                systemImage: "square.and.pencil"
            )
            .font(.subheadline)
            .foregroundStyle(Color("PrimaryBlue"))
        }
        .buttonStyle(.plain)
        
        .popover(
            isPresented: $isShowingTimePicker,
            attachmentAnchor: .rect(.bounds),
            arrowEdge: .top
        ) {
            CompactTimePicker(
                completedMinutes: $completedMinutes
            )
            .presentationCompactAdaptation(.popover)
        }
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(
                    Color("LightBlue").opacity(0.35),
                    lineWidth: 7
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color("PrimaryBlue"),
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .frame(width: 66, height: 66)
      
    }

    private var goalSection: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(
                    cornerRadius: 13,
                    style: .continuous
                )
                .fill(Color("SoftPink").opacity(0.35))

                Image(systemName: "book")
                    .font(.body)
                    .foregroundStyle(Color("SoftPink"))
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Your goal")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Learn Python")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Week 6 of 20")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private func durationText(
        _ totalMinutes: Int
    ) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        }

        if hours > 0 {
            return "\(hours)h"
        }

        return "\(minutes)m"
    }
}

private struct CompactTimePicker: View {
    @Binding var completedMinutes: Int

    @Environment(\.dismiss) private var dismiss

    @State private var selectedHours: Int
    @State private var selectedMinutes: Int

    private let maximumHours = 24

    init(
        completedMinutes: Binding<Int>
    ) {
        _completedMinutes = completedMinutes

        let currentMinutes = completedMinutes.wrappedValue

        _selectedHours = State(
            initialValue: min(currentMinutes / 60, 24)
        )

        _selectedMinutes = State(
            initialValue:
                currentMinutes >= 24 * 60
                ? 0
                : currentMinutes % 60
        )
    }

    private var maximumMinutes: Int {
        selectedHours == 24 ? 0 : 59
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Edit Progress")
                    .font(.headline)

                Spacer()

                Button("Done") {
                    saveTime()
                }
                .fontWeight(.semibold)
            }

            HStack(spacing: 12) {
                pickerColumn(
                    title: "Hours",
                    selection: $selectedHours,
                    range: 0...maximumHours
                )

                pickerColumn(
                    title: "Minutes",
                    selection: $selectedMinutes,
                    range: 0...maximumMinutes
                )
            }
            .frame(height: 135)
            .clipped()
        }
        .padding(16)
        .frame(width: 300, height: 205)
        .background(Color("CardBackground"))
        .onChange(of: selectedHours) {
            if selectedMinutes > maximumMinutes {
                selectedMinutes = maximumMinutes
            }
        }
    }

    private func pickerColumn(
        title: String,
        selection: Binding<Int>,
        range: ClosedRange<Int>
    ) -> some View {
        VStack(spacing: 2) {
            Picker(title, selection: selection) {
                ForEach(Array(range), id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .clipped()

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func saveTime() {
        completedMinutes =
            (selectedHours * 60) + selectedMinutes

        dismiss()
    }
}

#Preview {
    ProgressCardView()
        .padding(20)
        .background(Color("AppBackground"))
}
