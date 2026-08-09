//
//  OnboardingView.swift
//  FirstApp
//
//  Created by Nada Alsaeed on 26/02/1448 AH.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentQuestion = 1

    var body: some View {

    Group {

    if currentQuestion == 1 {

    Question1(
    next: {
    currentQuestion = 2
    }
    )

    } else if currentQuestion == 2 {

    Question2(
    next: {
    currentQuestion = 3
    },
    back: {
    currentQuestion = 1
    }
    )

    } else if currentQuestion == 3 {

    Question3(
    next: {
    currentQuestion = 4
    },
    back: {
    currentQuestion = 2
    }
    )

    } else if currentQuestion == 4 {

    Question4(
    next: {
    currentQuestion = 5
    },
    back: {
    currentQuestion = 3
    }
    )

    } else if currentQuestion == 5 {

    Question5(
    back: {
    currentQuestion = 4
    }
    )
    }
    }
    }
    }

    #Preview {
    OnboardingView()
    }
