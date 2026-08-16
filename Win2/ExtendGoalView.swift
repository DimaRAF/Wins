import SwiftUI

struct ExtendGoalView: View {
    @Binding var selectedDate: Date

    let onSave: () -> Void

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                Text(
                    "Choose a new target date"
                )
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

                Divider()

                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: minimumDate...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .frame(height: 220)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .navigationBarBackButtonHidden(true)

            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading
                ) {
                    Button {
                        dismiss()
                    } label: {
                        Image(
                            systemName: "xmark"
                        )
                        .font(
                            .title3.weight(.semibold)
                        )
                        .foregroundStyle(.black)
                    }
                }
            }

            .safeAreaInset(
                edge: .bottom
            ) {
                VStack {
                    Button {
                        onSave()
                    } label: {
                        Text("Extend Goal")
                            .font(
                                .system(
                                    size: 17,
                                    weight: .semibold
                                )
                            )
                            .foregroundColor(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(
                                            red: 0.22,
                                            green: 0.58,
                                            blue: 0.80
                                        ),
                                        Color(
                                            red: 0.43,
                                            green: 0.72,
                                            blue: 0.86
                                        )
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 18,
                                    style: .continuous
                                )
                            )
                            .shadow(
                                color:
                                    Color(
                                        red: 0.22,
                                        green: 0.58,
                                        blue: 0.80
                                    )
                                    .opacity(0.35),
                                radius: 15,
                                x: 0,
                                y: 8
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(.white)
            }
        }
    }

    private var minimumDate: Date {
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Calendar.current.startOfDay(
                for: Date()
            )
        ) ?? Date()
    }
}

#Preview {
    ExtendGoalView(
        selectedDate: .constant(
            Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: Date()
            )!
        ),
        onSave: {}
    )
}
