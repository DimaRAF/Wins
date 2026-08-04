import SwiftUI

struct FocusChartCardView: View {
    let weekTitle: String
    let dailyData: [DailyFocus]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("Minutes per Day")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(weekTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.17, green: 0.56, blue: 0.78))
                    .frame(width: 8, height: 8)
                
                Text("Today highlighted")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            ZStack(alignment: .bottom) {
                VStack(spacing: 18) {
                    ForEach(0..<5) { _ in
                        Divider()
                            .background(Color(.systemGray5))
                    }
                }
                .frame(height: 100)
                
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("50").font(.system(size: 10)).foregroundColor(.gray)
                        Text("40").font(.system(size: 10)).foregroundColor(.gray)
                        Text("30").font(.system(size: 10)).foregroundColor(.gray)
                        Text("20").font(.system(size: 10)).foregroundColor(.gray)
                        Text("10").font(.system(size: 10)).foregroundColor(.gray)
                        Text("0").font(.system(size: 10)).foregroundColor(.gray)
                    }
                    .frame(width: 20)
                    .padding(.bottom, 2)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 16) {
                        ForEach(dailyData) { data in
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(data.isToday ? Color(red: 0.17, green: 0.56, blue: 0.78) : Color(red: 0.54, green: 0.76, blue: 0.93))
                                    .frame(width: 18, height: max(CGFloat(data.minutes) * 1.6, 4))
                                
                                Text(data.day)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .frame(height: 120)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}
