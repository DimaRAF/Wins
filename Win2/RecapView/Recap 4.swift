//
//  Recap 4.swift
//  wins
//
//  Created by yara  on 21/02/1448 AH.
//

import SwiftUI

struct Recap_4: View {
    @Binding var currentPage: Int
    @Environment(\.dismiss) var dismiss
    let goalStartDate: Date
    let weeklyData: [DailyFocus]
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
    
    // البحث عن اليوم الذي اشتغل فيه المستخدم رغم أن طاقته كانت "Low"
    private var lowestEnergyWorkingDay: String {
        let store = DailyDataStore.shared
            // تصفية الأيام التي عمل فيها المستخدم فقط
        let workedDays = weeklyData.filter { $0.minutes > 0 }
            
            // 1. البحث عن اليوم المخزّن بطاقة Low
        if let lowEnergyDay = workedDays.first(where: { day in
            let energy = store.getDay(date: day.date)?.energy?.lowercased()
            return energy == "low"
        }) {
            return lowEnergyDay.day
        }
            
            // 2. إذا لم يوجد يوم Low، نبحث عن يوم Medium
        if let mediumEnergyDay = workedDays.first(where: { day in
            let energy = store.getDay(date: day.date)?.energy?.lowercased()
            return energy == "medium"
        }) {
            return mediumEnergyDay.day
        }
            
        // 3. خيار احتياطي في حال عدم وجود طاقة مسجلة
        return workedDays.first?.day ?? "N/A"
    }
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
                
                
                    Text(headerTitle)
                        .font(.system(size: 17))
                    Divider()
                        .frame(height: 2)
                        .overlay(Color.primaryBlue)
                        .padding(.horizontal, 120)
                
                
                Spacer()
                
            
                Text("🪫")
                    .font(.system(size: 200))
                    .padding(.bottom,40)
                
                Text("Unstoppable")
                        .font(.system(size: 24))
                    
                Text("Monday")
                        .font(.system(size: 64))
                        .foregroundStyle(.primaryBlue)
                    
                Text("Tired, but unstoppable.. Be proud of showing up! 🫡  ")
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
    Recap_4(currentPage: .constant(3), goalStartDate: Date(), weeklyData: [])
}
