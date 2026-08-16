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
    let goalStartDate: Date
        let date: Date = Date()

        private var calendar: Calendar {
            var cal = Calendar.current
            cal.firstWeekday = 1
            return cal
        }

        private var weekNumber: Int {
            let start = calendar.startOfDay(for: goalStartDate)
            let current = calendar.startOfDay(for: date)
            let days = calendar.dateComponents([.day], from: start, to: current).day ?? 0
            return max(1, days / 7)
        }

        private var headerTitle: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return "Week \(weekNumber), \(formatter.string(from: date))"
        }
    var body: some View {
        ZStack{
        Color.appBackground
            .ignoresSafeArea()
        VStack{
            Text(headerTitle)
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
                    .shadow(
                        color: Color(red: 0.22, green: 0.58, blue: 0.80).opacity(0.35),
                        radius: 15, x: 0, y: 8
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 75)
            
           }
        }
    }
}

#Preview {
    Recap_5(currentPage: .constant(4), goalStartDate: Date())
}
