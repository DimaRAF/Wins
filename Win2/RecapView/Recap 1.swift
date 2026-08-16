//
//  Recap 1.swift
//  wins
//
//  Created by yara  on 20/02/1448 AH.
//

import SwiftUI

struct Recap_1: View {
    @Binding var currentPage: Int
    
    let goalStartDate: Date
        let date: Date // التاريخ المراد عرض الـ Recap له (افتراضياً اليوم)
        
        init(currentPage: Binding<Int>, goalStartDate: Date, date: Date = Date()) {
            self._currentPage = currentPage
            self.goalStartDate = goalStartDate
            self.date = date
        }

        // MARK: - Computed Properties
        private var calendar: Calendar {
            var cal = Calendar.current
            cal.firstWeekday = 1 // الأحد هو بداية الأسبوع
            return cal
        }

    // حساب رقم الأسبوع المنتهي (الأسبوع السابق)
        private var weekNumber: Int {
            let start = calendar.startOfDay(for: goalStartDate)
            let current = calendar.startOfDay(for: date)
            let days = calendar.dateComponents([.day], from: start, to: current).day ?? 0
        
        // لحساب الأسبوع المنقضي نطرح 1
            let calculatedWeek = (days / 7)
            return max(1, calculatedWeek)
        }

        // نص الشهر والسنة (مثل: Aug 2026)
        private var monthYearString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: date)
        }

        // نص رأس الصفحة (مثل: Week 1, Aug 2026)
        private var headerTitle: String {
            "Week \(weekNumber), \(monthYearString)"
        }

        // نص العنوان الرئيسي
        private var mainWeekTitle: String {
            "Week \(weekNumber)"
        }
    
    var body: some View {
        ZStack{
            Color .appBackground
                .ignoresSafeArea()
            VStack{
                Text(headerTitle)
                    .font(.system(size: 17))
                    .padding(.top,40)
                Divider()
                    .frame(height: 2)
                    .overlay(Color .primaryBlue)
                    .padding(.horizontal, 120)
                
                Spacer()
                
                
                Text("Ready For Your")
                    .font(.system(size: 40))
                
                Text(mainWeekTitle)
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
    Recap_1(currentPage: .constant(0), goalStartDate: Date())
}
