//
//  Screen5 2.swift
//  DualSync
//
//  Created by Paula Mora Romero on 15/11/25.
//


//  Screen5.swift
//  DualSync
//
//  Created by Paula Mora Romero on 15/11/25.
//

import SwiftUI

struct Screen5: View {
    
    @State private var showText = false
    @State private var showImage = false
    @State private var textOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                
                Text("Both joysticks are synchronized")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .opacity(showText ? 1 : 0)
                    .offset(y: textOffset)
                    .animation(.easeOut(duration: 0.8), value: showText)
                
                
                if showImage {
                    Image("games")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 250)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.8), value: showImage)
                }
            }
        }
        .onAppear {
            // 1️⃣ APAREIX TEXT
            withAnimation {
                showText = true
            }
            
            // 2️⃣ APAREIX IMATGE + DESPLAçA TEXT
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    textOffset = -20
                    showImage = true
                }
            }
        }
        .toolbar(.hidden)
    }
}

