//
//  Recap 1.swift
//  wins
//
//  Created by yara  on 20/02/1448 AH.
//

import SwiftUI

struct Recap_1: View {
    @Binding var currentPage: Int
    var body: some View {
        ZStack{
            Color .appBackground
                .ignoresSafeArea()
            VStack{
                Text("week 1, Jul 2026 ")
                    .font(.system(size: 17))
                    .padding(.top,40)
                Divider()
                    .frame(height: 2)
                    .overlay(Color .primaryBlue)
                    .padding(.horizontal, 120)
                
                Spacer()
                
                
                Text("Ready For Your")
                    .font(.system(size: 40))
                
                Text("Jul 2026")
                    .font(.system(size: 64))
                    .foregroundStyle(.primaryBlue)
                
                Text("weekly recap?")
                    .font(.system(size: 32))
                
                Text("💪🏻")
                    .font(.system(size: 64))
                    .padding(.top, 20)
                
                Text("You were stronger than your procrastinating thoughts this week..")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.horizontal, 40)
                
                Spacer()
                Button {
                    currentPage += 1
                    
                }label: {
                    Text("Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 350)
                    .frame(height: 56)
                    .background(Color .primaryBlue)
                    .clipShape(Capsule())
                   
                }
                    .padding(.bottom, 75)
                
            }
        }
    }
}

#Preview {
    Recap_1(currentPage: .constant(0))
}
