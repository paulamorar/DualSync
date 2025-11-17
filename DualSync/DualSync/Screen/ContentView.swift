//
//  ContentView.swift
//  DualSync
//
//  Created by Paula Mora Romero on 11/11/25.
//

import SwiftUI
import GameController
import RealityKit

struct ContentView: View {
    
    @ObservedObject var controllerModel: ControllerRotation
    @State var isControllerOn = false
    
    @State private var showStep3 = false
    @State private var step3Offset: CGFloat = 50
    @State private var showModel = false
    @State private var showText = false
    @State private var textOffset: CGFloat = 30
    
    @State private var navigateToScreen5 = false
    
    
    @State private var fadeOut = false
    
    //TOT EL QUE ES MOSTRA A LA PANTALLA
    var body: some View {
        
        NavigationStack { // Necesario para navigationDestination
            ZStack {
                VStack {
                    
                    // IMAGEN STEP3 CON ANIMACION
                    Image("step3")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 200, height: 100)
                        .opacity(showStep3 ? 1 : 0)
                        .offset(y: step3Offset)
                        .animation(.easeOut(duration: 0.8), value: showStep3)
                    
                    //REALITYVIEW = CARREGAR MODEL3D I TEXT
                    RealityView { content in
                        // Cargar el modelo .usdz y espera que cargue | entity = nou nom
                        if let entity = try? await Entity(named: "PS5controller") {
                            content.add(entity)
                            
                            entity.setScale(SIMD3<Float>(repeating: 0.003), relativeTo: nil)
                            //especificar % mida original y nil = no comparar a nada, sobre sí mismo
                            
                            // ASIGNAR AL MODEL ENTITY PARA QUE PUEDA GIRAR
                            controllerModel.modelEntity = entity
                        }
                    }
                    .frame(height: 300)
                    .opacity(showModel ? 1 : 0)          // Apareix amb transició
                    .offset(y: showModel ? 0 : 50)       // Des de sota
                    .animation(.easeOut(duration: 0.8), value: showModel)
                    
                    ZStack {
                        Text("Check both joysticks")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .opacity(showText ? 1 : 0)
                            .offset(y: textOffset)
                            .animation(.easeOut(duration: 0.6), value: showText)
                    }
                }
                .opacity(fadeOut ? 0 : 1)   // FADE OUT GENERAL
                .animation(.easeInOut(duration: 0.8), value: fadeOut)
            }
            
            .toolbar(.hidden)
            .onAppear {
                // AIXÒ DETECTA SI JA ESTAVA CONNECTAT D'ABANS, PQ SINO ESPERA UNA CONNEXIÓ NOVA
                if let controller = GCController.controllers().first {
                    controllerModel.controller = controller
                    controllerModel.connectController()
                }
                
                controllerModel.onBothJoysticksMoved = {
                    
                    withAnimation {
                        fadeOut = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        navigateToScreen5 = true
                    }
                }
                
                // 1️⃣ APAREIX IMATGE
                withAnimation {
                    showStep3 = true
                }
                
                // 2️⃣ DESPRÉS ES DESPLAçA
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                        step3Offset = 20
                    }
                }
                
                // 3️⃣ DESPRÉS MODEL 3D
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    withAnimation {
                        showModel = true
                    }
                }
                
                // 4️⃣ TEXT
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                    showText = true
                    
                    // FADE OUT I VA A LA SCREN5
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        withAnimation {
                            fadeOut = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            navigateToScreen5 = true
                        }
                    }
                }
            }
            
            .navigationDestination(isPresented: $navigateToScreen5) {
                Screen5()
            }
            
            //DETECTAR CONNEXIÓ MANDOS CADA COP
            .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidConnect)) { notification in
                isControllerOn = true
                if let controller = notification.object as? GCController {
                    controllerModel.controller = controller
                    controllerModel.connectController()
                }
            }
            
            //DETECTAR SI ESTÀ DESCONNECTAT
            .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidDisconnect)) { _ in
                isControllerOn = false
            }
        }
    }
}


