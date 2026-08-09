//
//  Question3.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 21/02/1448 AH.
//

import SwiftUI

struct Question3: View {
    @State private var selectedMinimum = "10 min"

    let minimumOptions = [
    "10 min",
    "15 min",
    "20 min",
    "25 min",
    "30 min"
    ]

    let next: () -> Void
    let back: () -> Void

    var body: some View {

    NavigationStack {

    VStack(alignment: .leading, spacing: 20) {

    Text("Minimum daily time for your goal?")
    .font(.largeTitle)
    .fontWeight(.bold)
    .frame(maxWidth: .infinity, alignment: .leading)

    Divider()

    Picker("", selection: $selectedMinimum) {

    ForEach(minimumOptions, id: \.self) { option in
    Text(option)
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
    .fill(.black)
    .frame(width: 8, height: 8)

    Circle()
    .fill(.gray.opacity(0.35))
    .frame(width: 8, height: 8)

    Circle()
    .fill(.gray.opacity(0.35))
    .frame(width: 8, height: 8)
    }

    Text("Step 3 of 5")
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
    Question3(
    next: {},
    back: {}
    )
    }
