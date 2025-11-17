import SwiftUI
import AppKit

struct GIFView: NSViewRepresentable {
    let name = "Checked" // nombre del GIF, sin extensión
    var width: CGFloat = 30
    var height: CGFloat = 30
    var onAnimationEnd: (() -> Void)? = nil

    func makeNSView(context: Context) -> NSImageView {
            let imageView = NSImageView()
            imageView.canDrawSubviewsIntoLayer = true
            imageView.imageScaling = .scaleAxesIndependently
            imageView.translatesAutoresizingMaskIntoConstraints = false
        
            if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
                let image = NSImage(byReferencing: url)
                imageView.image = image
                imageView.animates = true
            
            // Hacer que se reproduzca solo 1 vez
            if let tiffRep = image.tiffRepresentation, let gif = NSBitmapImageRep(data: tiffRep) {
                gif.value(forProperty: .loopCount) // loopCount = 0 = infinito, 1 = una vez
                gif.setProperty(.loopCount, withValue: 1)
            }
        }

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])

        // Ejecutar callback después de la duración aproximada del GIF
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 segundo aprox.
            onAnimationEnd?()
        }

        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: Context) {
        nsView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                constraint.constant = width
            } else if constraint.firstAttribute == .height {
                constraint.constant = height
            }
        }
    }
}

