# Game Controller Tester App 

Game Controller Tester is an iOS app built in SwiftUI designed to help users check that their game controllers are properly connected and that all buttons and joysticks respond correctly. It’s a learning-focused project that explores Apple frameworks such as GameController and RealityKit, with simple animations and an Apple-inspired UI.

The app was developed with the goal of learning framework integration, interactive UI, and 3D model manipulation in SwiftUI. While it’s not a full-fledged utility, it simulates the essential experience of testing a controller on macOS/iOS devices.

## 📸 Features
### Controller Connection Check
•	Detects if a game controller is connected to the Mac.
•	Shows visual feedback when the controller is recognized

### Button Synchronization Phase
•	Users can test individual buttons (A, B, X, Y)
•	Visual feedback shows which buttons are pressed
•	Animations highlight button interaction

### Joystick Test Phase
•	Tests both joysticks for movement detection
•	Displays a “Joysticks are synchronized” message when both joysticks are moved
•	Automatically navigates to the final screen after successful joystick test

### Interactive 3D Model
•	3D model of a game controller displayed via RealityKit
•	Users can rotate the model with the joysticks
•	Simple scaling and animation to improve visual feedback

### Apple-Style UI
•	Clean typography, spacing, and minimalistic design
•	Smooth transitions and animations for better interaction

## 🏗 Tech Stack
•	SwiftUI – Declarative UI framework
•	RealityKit – 3D model rendering and interaction
•	GameController Framework – Detecting controllers and handling input

## 🎯 Learning Goals
This project helped me:
•	Implement and interact with Apple frameworks (GameController, RealityKit)
•	Handle controller input, including buttons and joysticks
•	Coordinate UI animations based on hardware input
•	Structure a SwiftUI app into multiple phases/screens
•	Prepare for future interactive applications or video game interfaces

## 🚀 Next Steps
Future improvements could include:

### ✨ UI & UX Enhancements
•	More polished button animations
•	Improved transitions between phases
•	Feedback for haptic or motion input

### ✨ New Features
•	Add vibration feedback using Core Haptics
•	Expand 3D model interaction with more complex gestures
•	Implement a full controller configuration panel

### ✨ Technical Additions
•	Improve joystick detection and calibration
•	Add unit tests for controller input handling
•	Explore multiplayer/game interaction simulation

🔗 GitHub Repository
https://github.com/paulamorar/DualSync.git
