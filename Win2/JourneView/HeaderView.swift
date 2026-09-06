import SwiftUI

struct HeaderView: View {
    
    let targetDate: Date
    let goalStartDate: Date
    let totalMonths: Int
    
    @Binding var selectedMonth: Int
    
    var body: some View {
        HStack(alignment: .center) {
            
            Text("Journey")
                .font(
                    .system(
                        size: 40,
                        weight: .bold
                    )
                )
                .foregroundColor(.black)
            
            Spacer()
            
            Menu {
                
                ForEach(
                    1...totalMonths,
                    id: \.self
                ) { month in
                    
                    Button {
                        
                        selectedMonth = month
                        
                    } label: {
                        
                        if month == selectedMonth {
                            
                            Label(
                                "Month \(month)",
                                systemImage: "checkmark"
                            )
                            
                        } else {
                            
                            Text(
                                "Month \(month)"
                            )
                        }
                    }
                }
                
            } label: {
                
                HStack(spacing: 12) {
                    
                    Image(
                        systemName: "calendar"
                    )
                    .font(
                        .system(size: 14)
                    )
                    
                    Text(
                        "Month \(selectedMonth)"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    
                    Image(
                        systemName: "chevron.down"
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .semibold
                        )
                    )
                }
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .frame(height: 35)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18
                    )
                )
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 10,
                    x: 0,
                    y: 5
                )
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
    
}
#Preview {

    HeaderView(
        targetDate: Calendar.current.date(
            byAdding: .day,
            value: 120,
            to: Date()
        )!,
        goalStartDate: Date(),
        totalMonths: 4,
        selectedMonth: .constant(1)
    )
}
