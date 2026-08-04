//test
import SwiftUI

struct WeeklyReflectionCardView: View {
    let insights: [InsightItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                Image(systemName: "star")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Personalized Insights")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Based on this week's data")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            
            VStack(spacing: 8) {
                ForEach(insights) { insight in
                    HStack(spacing: 10) {
                        Image(systemName: insight.icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(insight.theme.iconColor)
                            .frame(width: 28, height: 28)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                        
                        Text(insight.text)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.black)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                    .padding(10)
                    .background(insight.theme.backgroundColor)
                    .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color(red: 0.94, green: 0.96, blue: 1.0))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}
