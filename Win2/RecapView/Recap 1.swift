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
                    .padding(.bottom, 75)
                
            }
        }
    }
}

#Preview {
    Recap_1(currentPage: .constant(0))
}
