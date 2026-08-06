//
//  Recap 5.swift
//  wins
//
//  Created by yara  on 21/02/1448 AH.
//

import SwiftUI

struct Recap_5: View {
    @Binding var currentPage: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
        Color.appBackground
            .ignoresSafeArea()
        VStack{
            Text("week 1, Jul 2026 ")
                .font(.system(size: 17))
                .padding(.top,40)
            Divider()
                .frame(height: 2)
                .overlay(Color.primaryBlue)
                .padding(.horizontal, 120)
            Spacer()
            
            
            Text("Focus Personality")
                .font(.system(size: 24))
            
            Text("Consistent Achiever")
                .font(.system(size: 32))
                .foregroundStyle(.primaryBlue)
                .padding(.bottom, 27)
            
            Text("Total minutes")
                .font(.system(size: 24))
            Text("170 min")
                .font(.system(size: 32))
                .foregroundStyle(.primaryBlue)
                .padding(.bottom, 27)
            
            Text("BEST day")
                .font(.system(size: 24))
            Text("Tusday")
                .font(.system(size: 32))
                .foregroundStyle(.primaryBlue)
                .padding(.bottom, 27)
            
            Text("🏆")
                .font(.system(size: 80))
                .padding(.top, 20)
             Spacer()
            
          
            Button {
                dismiss()
                
            }label: {
                Text("Done")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 350)
                .frame(height: 56)
                .background(Color.primaryBlue)
                .clipShape(Capsule())
               
            }
             
                .padding(.bottom, 75)
            
           }
        }
    }
}

#Preview {
    Recap_5(currentPage: .constant(4))
}
