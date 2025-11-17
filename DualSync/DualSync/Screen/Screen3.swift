import SwiftUI
import GameController

struct Screen3: View {
    @State private var showImage = false
    @State private var showText = false
    @State private var imageOffset: CGFloat = 0
    @State var isControllerOn = false
    @State var navigateToContentView = false
    @StateObject var controllerModel = ControllerRotation()
    
    @State private var buttonAPressed = false
    @State private var buttonBPressed = false
    @State private var buttonXPressed = false
    @State private var buttonYPressed = false
    
    @State private var showSyncMessage = false
    @State private var fadeOut = false
    
    //Imatge que es mostra depenent de quin botó s'apreta
    @State private var currentButtonImage: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    if showText {
                        Text("Test your buttons")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .transition(.opacity)
                            .padding(.bottom, 5)
                            .animation(.easeIn(duration: 0.8), value: showText)
                    }
                    
                    
                    Image("step2")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 200, height: 100)
                        .opacity(showImage ? 1 : 0)
                        .offset(y: imageOffset - 10)
                        .animation(.easeOut(duration: 0.8), value: imageOffset)
                    
                    // Imatge que canvia al apretar botons
                    if let buttonImage = currentButtonImage {
                        Image(buttonImage) // "A", "B", "X", "Y"
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 150)
                            .transition(.scale.combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.5), value: currentButtonImage)
                    }
                    
                    
                    if showSyncMessage {
                        Text("Buttons are synchronized")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.8), value: showSyncMessage)
                    }
                }
                
                .opacity(fadeOut ? 0 : 1)
                .navigationDestination(isPresented: $navigateToContentView) {
                    ContentView(controllerModel: controllerModel)
                }
                
                .toolbar(.hidden)
                .onAppear {
                    // 1️⃣ APAREIX IMATGE
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeIn(duration: 1.2)) {
                            showImage = true
                        }
                    }
                    
                    // 2️⃣ ES DESPLAçA + APAREIX TEXT
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                                imageOffset = 50
                                showText = true
                        }
                    }
                    
                    // CONDIGURA ELS HANDLERS DELS MANDOS JA CONNECTATS
                    for controller in GCController.controllers() {
                        setupButtonHandlers(for: controller)
                    }
                }
                
                // Conectar mando
                .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidConnect)) { notification in
                    isControllerOn = true
                    if let controller = notification.object as? GCController {
                        setupButtonHandlers(for: controller)
                    }
                }
                
                // Desconectar mando
                .onReceive(NotificationCenter.default.publisher(for: .GCControllerDidDisconnect)) { _ in
                    isControllerOn = false
                }
            }
        }
    }
    // BOTONS
    func setupButtonHandlers(for controller: GCController) {
        controller.extendedGamepad?.buttonA.pressedChangedHandler = { _, _, pressed in
            if pressed {
                print("Button X pressed!")
                buttonAPressed = true                  // marcar como pulsado
                withAnimation { currentButtonImage = "x" }
                checkAllButtonsPressed()
            }
        }
        controller.extendedGamepad?.buttonB.pressedChangedHandler = { _, _, pressed in
            if pressed {
                print("Button O pressed!")
                buttonBPressed = true
                withAnimation { currentButtonImage = "o" }
                checkAllButtonsPressed()
            }
        }
        controller.extendedGamepad?.buttonX.pressedChangedHandler = { _, _, pressed in
            if pressed {
                print("Button Q pressed!")
                buttonXPressed = true
                withAnimation { currentButtonImage = "a" }
                checkAllButtonsPressed()
            }
        }
        controller.extendedGamepad?.buttonY.pressedChangedHandler = { _, _, pressed in
            if pressed {
                print("Button T pressed!")
                buttonYPressed = true
                withAnimation { currentButtonImage = "b" }
                checkAllButtonsPressed()
            }
        }
    }
    
    // COMPROVAR SI ELS 4 S'HAN APRETAT
    func checkAllButtonsPressed() {
        if buttonAPressed && buttonBPressed && buttonXPressed && buttonYPressed {
            withAnimation {
                showSyncMessage = true
            }
            
            //ANIMACIÓ A TOTA LA PANTALLA
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { fadeOut = true }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                navigateToContentView = true
                
                }
            }
        }
    }
}
