//
//  ControllerRotation.swift
//  DualSync
//
//  Created by Paula Mora Romero on 12/11/25.
//

import SwiftUI
import GameController
import RealityKit
import Combine

class ControllerRotation: ObservableObject { //que pugui ser observada per swiftUI
    @Published var controller: GCController? //mando     | @Published fa q s'actualitzin automàaticament
    @Published var modelEntity: Entity? // model3d
    
    var currentAngleY: Float = 0
    var currentAngleX: Float = 0
    
    
    //AQUESTS GUARDEN VALOR ACTUAL DEL JOYSTICK
    var xValue: Float = 0
    var yValue: Float = 0
    
    //TIMER X ROTAICÓ CONTINUA
    var rotationTimer: Timer?
    
    var onBothJoysticksMoved: (() -> Void)?  // se llamará cuando ambos se muevan
    var leftMoved = false
    var rightMoved = false
    
    func connectController() {
        
        //COMPROVA QUE SIGUI UN MANDO DE PS5 (AMB BOTONS I JOYSTICKS)
        guard let gamepad = controller?.extendedGamepad else { return }
        
        // CADA COP QUE ES MOGUI EL JOYSTICK ESQUERRE, ES GUARDA EL SEU VALOR ACTUAL
        gamepad.leftThumbstick.valueChangedHandler = { [weak self] _, x, y in //weak self = evitra un memory leak
            guard let self = self else { return }
            self.xValue = x
            self.yValue = y
            if abs(x) > 0.1 || abs(y) > 0.1 { self.rightMoved = true }
            self.checkBothMoved()
        }
        
        // CADA COP QUE ES MOGUI EL JOYSTICK DRET, ES GUARDA EL SEU VALOR ACTUAL
        gamepad.rightThumbstick.valueChangedHandler = { [weak self] _, x, y in //weak self = evitra un memory leak
            guard let self = self else { return }
            self.xValue = x
            self.yValue = y
            if abs(x) > 0.1 || abs(y) > 0.1 { self.rightMoved = true }
            self.checkBothMoved()
        }
        
        // TIMER QUE ACTUALITZA LA ROTACIÓ CONSTANTMENT
        rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in //0.016 = 60FPS | repeats = true -> no es para de moure fins que es pari
            self?.updateRotation() //crida al model que aplica la rotació del model
        }
    }
    
    
    func updateRotation() {
        guard let entity = modelEntity else { return }  //primer comprova que que le model3d existeixi, sino = return (surt)
        
        // Si el joystick no está en el centro
        if abs(xValue) > 0.05 || abs(yValue) > 0.05 {
            let sensitivity: Float = 0.02
            
            // Ajustamos los límites máximos
            let adjustedX = max(min(xValue, 1.0), -1.0)
            let adjustedY = max(min(yValue, 1.0), -1.0)
            
            // Acumulamos los ángulos
            currentAngleY += adjustedX * sensitivity
            currentAngleX -= adjustedY * sensitivity
            
            // Creamos las rotaciones
            let rotationY = simd_quatf(angle: currentAngleY, axis: [0, 1, 0])
            let rotationX = simd_quatf(angle: currentAngleX, axis: [1, 0, 0])
            
            // Aplicamos la orientación
            entity.orientation = rotationY * rotationX
        }
        
    }
    func checkBothMoved() {
        if leftMoved && rightMoved {
            onBothJoysticksMoved?()
            leftMoved = false
            rightMoved = false
        }
        
    }
}

    
    
    
    
