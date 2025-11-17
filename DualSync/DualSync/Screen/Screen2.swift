//
//  Screen2.swift
//  DualSync
//
//  Created by Paula Mora Romero on 13/11/25.
//

import SwiftUI
import GameController

struct Screen2: View {
    
    @State private var showImage = false
    @State private var showText = false
    @State private var imageOffset: CGFloat = 0
    @State var controllerConnected = false
    @State var isControllerOn = false
    @State var confirmedConnection = false
    @State var navigateToScreen3 = false
    
    @State private var fadeOut = false
    @State private var bounceOffset: CGFloat = 0   
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 10) {
                    
                    Image("step1")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 200, height: 100)
                        .opacity(showImage ? 1 : 0)
                        .offset(y: imageOffset)
                        .animation(.easeOut(duration: 0.8), value: imageOffset)
                    
                    if showText {
                        VStack(spacing: 15) {
                            Text("Connect your controller")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            // TOGGLE CANVIA SEGONS SI ESTÀ CONNECTAT
                            if isControllerOn {
                                
                                Text("Controller is on")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                    .offset(y: bounceOffset)
                                    .animation(.interpolatingSpring(stiffness: 120, damping: 10), value: bounceOffset)
                                
                            } else {
                                
                                Text("Controller is off")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .offset(y: bounceOffset)
                                    .animation(.interpolatingSpring(stiffness: 120, damping: 10), value: bounceOffset)
                                
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 1), value: showText)
                        
                    }
                    
                }
                
                .opacity(fadeOut ? 0 : 1)
                .animation(.easeInOut(duration: 0.8), value: fadeOut)
                
                .navigationDestination(isPresented: $navigateToScreen3) {
                    Screen3()
                }
                
                //DETECTAR CONNEXIÓ MANDOS CADA COP
                .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidConnect)) { _ in
                    isControllerOn = true
                    
                    // Esperar 5 segundos, animar fadeOut y luego navegar a Screen3
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if isControllerOn {  // segueix conectat?
                            withAnimation {
                                fadeOut = true
                            }
                            
                            // Navegar després a l'animació
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                navigateToScreen3 = true
                            }
                        }
                    }
                }
                
            }
            .toolbar(.hidden)
            
            .onAppear {
                // 1️⃣ IMATGE
                withAnimation(.easeIn(duration: 1.2)) {
                    showImage = true
                }
                
                // 2️⃣ TEXT + IMATGE ES MOU CAP A DALT
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                        showText = true
                        imageOffset = -20       // quant es mou la imatge
                    }
                }
            }
            
            // DETECTA SI ESTÀ CONNECTAT O NO PER FER L'ANIMACIÓ I CANVIAR DE TEXT
            .onChange(of: isControllerOn) { _ in
                bounceOffset = -10
                withAnimation(.interpolatingSpring(stiffness: 120, damping: 10)) {
                    bounceOffset = 0
                }
            }
            
            //DETECTAR SI ESTÀ DESCONNECTAT
            .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidDisconnect)) { _ in
                isControllerOn = false
            }
        }
    }
}
