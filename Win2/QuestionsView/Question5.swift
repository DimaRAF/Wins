//
//  Question5.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 21/02/1448 AH.
//

import SwiftUI

struct Question5: View {
    @Binding var selectedDate: Date

    let next: () -> Void
    let back: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("When do you want to achieve your goal?")
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
                    in: Calendar.current.startOfDay(for: Date())...,
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
                                .fill(.gray.opacity(0.35))
                                .frame(width: 8, height: 8)

                            Circle()
                                .fill(.black)
                                .frame(width: 8, height: 8)
                        }

                        Text("Step 5 of 5")
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
    Question5(
        selectedDate: .constant(Date()),
        next: {},
        back: {}
    )
}
