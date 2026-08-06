//
//  control.swift
//  wins
//
//  Created by yara  on 21/02/1448 AH.
//

import SwiftUI

struct control: View {
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
        .fullScreenCover(isPresented: $navigationToRecap){
            
            TabView(selection: $currentPage){
                Recap_1(currentPage: $currentPage)
                    .tag(0)
                Recap_2(currentPage: $currentPage)
                    .tag(1)
                Recap_3(currentPage: $currentPage)
                    .tag(2)
                Recap_4(currentPage: $currentPage)
                    .tag(3)
                Recap_5(currentPage: $currentPage)
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
        
    }
func checkIfSundayAndShowAlert(){
    let today = Date()
    let weekday = Calendar.current.component(.weekday, from: today)
    showAlert = true
    }
}

#Preview {
    control()
}
