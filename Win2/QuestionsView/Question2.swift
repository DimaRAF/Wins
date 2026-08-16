import SwiftUI

struct Question2: View {
    @Binding var whyGoalMatters: String

    let next: () -> Void
    let back: () -> Void

    @State private var showError = false

    private var isAnswerEmpty: Bool {
        whyGoalMatters
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("Why is this goal important to you?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Divider()

                TextField(
                    "Write your answer here...",
                    text: $whyGoalMatters
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .onChange(of: whyGoalMatters) { _, newValue in

                    if !newValue
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty {

                        showError = false
                    }
                }

                // Error message
                if showError {
                    HStack(spacing: 6) {

                        Image(
                            systemName:
                                "exclamationmark.circle.fill"
                        )
                        .foregroundStyle(.red)

                        Text("Please enter your answer.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .navigationBarBackButtonHidden(true)

            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        back()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.black)
                    }
                }
            }

            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 14) {

                    Button {
                        if isAnswerEmpty {
                            showError = true
                        } else {
                            showError = false
                            next()
                        }
                    } label: {
                        Text("Next")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.22, green: 0.58, blue: 0.80),
                                        Color(red: 0.43, green: 0.72, blue: 0.86)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: Color(red: 0.22, green: 0.58, blue: 0.80).opacity(0.35), radius: 15, x: 0, y: 8)
                    }

                    VStack(spacing: 6) {
                        HStack(spacing: 8) {

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.black)
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)
                        }

                        Text("Step 2 of 5")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(.white)
            }
        }
    }
}

#Preview {
    Question2(
        whyGoalMatters: .constant(""),
        next: {},
        back: {}
    )
}
