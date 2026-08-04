//test
import SwiftUI

struct HeaderView: View {
    
    @State private var selectedMonth = 3
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            
            //topic page
            Text("My Journey")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 2)
                .padding(.top, 10)
            
            //month picker
            Menu {

                        ForEach(1...12, id: \.self) { month in

                            Button {

                                selectedMonth = month

                            } label: {

                                if month == selectedMonth {
                                    Label("Month \(month)", systemImage: "checkmark")
                                } else {
                                    Text("Month \(month)")
                                }

                            }

                        }

                    } label: {

                        HStack(spacing: 12) {

                            Image(systemName: "calendar")
                                .font(.system(size: 16))

                            Text("Month \(selectedMonth)")
                                .font(.system(size: 16, weight: .semibold))

                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))

                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .frame(height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.08),
                                radius: 10,
                                x: 0,
                                y: 5)

                    }

                

            
        }.padding(.horizontal, 10)
            .padding(.top, 5)

    }
}
    
    #Preview
    {
        HeaderView()
    }

