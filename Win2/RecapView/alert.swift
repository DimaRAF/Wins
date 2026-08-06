//
//  SwiftUIView.swift
//  wins
//
//  Created by yara  on 20/02/1448 AH.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var currentPage = 0
    @State private var showAlert = false
    @State private var navigationToRecap = false
    @Environment(\.scenePhase) var scenPhase
    var body: some View {
        NavigationStack{
            VStack{
                Text("main page")
                    .font(.title)
            }
            .navigationDestination(isPresented: $navigationToRecap){
                Recap_1(currentPage: $currentPage)
            }
            .alert("Your Weekly Story Is Ready!", isPresented: $showAlert){
                Button("View Weekly Recap"){
                    navigationToRecap = true
                }
                Button("maybe later", role: .cancel){}
            }message: {
                Text("Discover your wins and progress this week and celebrate your journey")
            }
            .onAppear{
                checkIfSundayAndShowAlert()
            }
            .onChange(of: scenPhase){ _, newphase in
                if newphase == .active {
                    checkIfSundayAndShowAlert()
                }
            }
        }
    }
    func checkIfSundayAndShowAlert(){
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        showAlert = true
        }
    }


#Preview {
    SwiftUIView()
}
