//
//  Recap 3.swift
//  wins
//
//  Created by yara  on 21/02/1448 AH.
//

import SwiftUI

struct Recap_3: View {
    @Binding var currentPage: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Color.appBackground
                .ignoresSafeArea()
                
                
            VStack{
                HStack(alignment: .center){
                    Button(action: {
                    withAnimation{
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3 .weight(.semibold))
                        .foregroundColor(.black)
                        .frame(width: 37, height: 37)
                        .background(Color.white .opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
                Spacer()
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "xmark")
                        .font(.title3 .weight(.semibold))
                        .foregroundColor(.black)
                        .frame(width: 37, height: 37)
                        .background(Color.white .opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)
            }
                
                
                    Text("week 1, Jul 2026 ")
                        .font(.system(size: 17))
                    Divider()
                        .frame(height: 2)
                        .overlay(Color.primaryBlue)
                        .padding(.horizontal, 120)
                
                
                Spacer()
                
            
                Text("🌟")
                    .font(.system(size: 200))
                    .padding(.bottom,40)
                
                Text("Your BEST day")
                        .font(.system(size: 24))
                    
                Text("Tusday")
                        .font(.system(size: 64))
                        .foregroundStyle(.primaryBlue)
                    
                Text("You were on fire this day! Keep that momentum going..🚀  ")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 27)
                    .padding(.bottom, 20)
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
                    .background(Color.primaryBlue)
                    .clipShape(Capsule())
                   
                }
                .padding(.bottom, 70)
            }
        }
        
    }
}

#Preview {
    Recap_3(currentPage: .constant(2))
}
