//test
//  ContentView.swift
//  Win2
//
//  Created by Dima Rafat on 21/02/1448 AH.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 1) {
                    VStack(alignment: .leading, spacing: 1) {
                        
                        HeaderView()
                        MainView()
                        
                        
                        
                        
                    }
                    .padding(.horizontal,2)
                    .padding(.top,-25)
                    
                }
                
            }
            
        }
        .background(Color(.systemGroupedBackground))
    }
    
    
}
#Preview {
    ContentView()
}
