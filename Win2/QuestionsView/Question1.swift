//
//  Question1.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 21/02/1448 AH.
//

import SwiftUI

struct Question1: View {
    @Binding var goal: String

    let next: () -> Void

    private var isGoalEmpty: Bool {
        goal.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("What goal do you want to achieve?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Divider()

                TextField(
                    "Write your answer here...",
                    text: $goal
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .bottom) {

                VStack(spacing: 14) {

                    Button {
                        next()
                    } label: {

                        Text("Next")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Color(
                                    red: 42 / 255,
                                    green: 146 / 255,
                                    blue: 201 / 255
                                )
                            )
                            .clipShape(Capsule())
                    }
                    .disabled(isGoalEmpty)
                    .opacity(isGoalEmpty ? 0.5 : 1)

                    VStack(spacing: 6) {

                        HStack(spacing: 8) {

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

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)
                        }

                        Text("Step 1 of 5")
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
    Question1(
        goal: .constant(""),
        next: {}
    )
}
