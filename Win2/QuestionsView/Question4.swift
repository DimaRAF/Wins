//
//  Question4.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 21/02/1448 AH.
//

import SwiftUI

struct Question4: View {
    @Binding var selectedMaximumMinutes: Int

    let maximumOptions = [
        45,
        60,
        90,
        120,
        150,
        180
    ]

    let next: () -> Void
    let back: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("Maximum daily time for your goal?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Divider()

                Picker(
                    "",
                    selection: $selectedMaximumMinutes
                ) {
                    ForEach(maximumOptions, id: \.self) { minutes in
                        Text(durationText(minutes))
                            .tag(minutes)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 180)

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

                    VStack(spacing: 6) {
                        HStack(spacing: 8) {

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
                                .fill(.black)
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)
                        }

                        Text("Step 4 of 5")
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

    private func durationText(_ minutes: Int) -> String {
        switch minutes {
        case 60:
            return "1 hour"
        case 90:
            return "1 hr 30 min"
        case 120:
            return "2 hours"
        case 150:
            return "2 hr 30 min"
        case 180:
            return "3 hours"
        default:
            return "\(minutes) min"
        }
    }
}

#Preview {
    Question4(
        selectedMaximumMinutes: .constant(45),
        next: {},
        back: {}
    )
}
