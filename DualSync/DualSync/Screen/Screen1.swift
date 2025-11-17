//
//  Screen1.swift
//  DualSync
//
//  Created by Paula Mora Romero on 13/11/25.
//

import SwiftUI

struct Screen1: View {
    
    @State private var logoOpacity: Double = 0   // controla la opacitat
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .opacity(logoOpacity)  // juga amb la opacitat
                
                
                    .navigationDestination(isPresented: $navigate) {
                            Screen2()
                                .navigationBarBackButtonHidden(true)
                                .transaction { t in t.disablesAnimations = true }
                }
            }
            
            .transaction { t in t.disablesAnimations = true }
            .onAppear {
                // 1️⃣ TRANSIICÓ
                withAnimation(.easeIn(duration: 1.2)) {
                    logoOpacity = 1
                }
                
                // 2️⃣ TRANSICIÓ (desapareix)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 1.5)) {
                        logoOpacity = 0
                    }
                }
                
                // 3️⃣ SEGÜENT PANTALLA
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    navigate = true
                }
            }
        }
    }
}


