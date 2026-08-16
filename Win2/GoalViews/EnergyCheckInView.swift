import SwiftUI

enum EnergyLevel: String, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: Self { self }

    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }

    var emoji: String {
        switch self {
        case .low:
            return "😴"
        case .medium:
            return "😐"
        case .high:
            return "😁"
        }
    }

    var message: String {
        switch self {
        case .low:
            return "Take it easy. Even a small step counts today."
        case .medium:
            return "You're in a good place to make steady progress."
        case .high:
            return "Great energy! Make the most of your momentum."
        }
    }

    var accentColor: Color {
        switch self {
        case .low:
            return Color("SoftPink")
        case .medium:
            return Color("PrimaryYellow")
        case .high:
            return Color("LightBlue")
        }
    }
}

struct EnergyCheckInView: View {

    @Binding var selectedEnergy: EnergyLevel?
    
    init(selectedEnergy: Binding<EnergyLevel?>) {
        _selectedEnergy = selectedEnergy
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            headerSection

            HStack(spacing: 12) {
                ForEach(EnergyLevel.allCases) { level in
                    energyButton(for: level)
                }
            }

            if let selectedEnergy {
                messageView(for: selectedEnergy)
                    .transition(
                        .opacity.combined(with: .move(edge: .top))
                    )
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            .stroke(Color("CardBorder"), lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 4
        )
        .animation(
            .snappy(duration: 0.25),
            value: selectedEnergy
        )
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Energy check-in")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let selectedEnergy {
                Text("\(selectedEnergy.title) energy today")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .transition(.opacity)
            } else {
                Text("How's your energy today?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .transition(.opacity)
            }
        }
    }

    private func energyButton(
        for level: EnergyLevel
    ) -> some View {

        let isSelected = selectedEnergy == level

        return Button {
            selectedEnergy = level
        } label: {

            VStack(spacing: 10) {

                Text(level.emoji)
                    .font(.largeTitle)

                Text(level.title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(
                    isSelected
                    ? level.accentColor.opacity(0.35)
                    : Color("EnergyBox")
                )
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .stroke(
                    isSelected
                    ? borderColor(for: level)
                    : Color.clear,
                    lineWidth: 2
                )
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
       
    }

    private func messageView(
        for level: EnergyLevel
    ) -> some View {

        Text(level.message)
            .font(.subheadline)
            .foregroundStyle(.primary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
                .fill(level.accentColor.opacity(0.45))
            }
           
    }

    private func borderColor(
        for level: EnergyLevel
    ) -> Color {

        switch level {
        case .low:
            return Color("SoftPink")

        case .medium:
            return Color("PrimaryYellowBorder")

        case .high:
            return Color("LightBlue")
        }
    }
}

#Preview {
    EnergyCheckInView(
        selectedEnergy: .constant(.medium)
    )
    .padding(20)
    .background(Color("AppBackground"))
}
