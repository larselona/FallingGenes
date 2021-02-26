//
//  ViewController.swift
//  FallingGenes
//
//  Created by Lars Isdahl on 26/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = GradientView()
        background.startColor = UIColor(red: 0.1, green: 0.25, blue: 0.5, alpha: 1)
        background.endColor = UIColor(red: 0.75, green: 0.8, blue: 0.9, alpha: 1)
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        let particles = ParticleView()
        particles.particleImage = UIImage(named: "dnagradient")
        particles.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(particles)
        
        let foreground = ShapeView()
        foreground.path = makeForeGround()
        foreground.strokeColor = .white
        foreground.fillColor = .gray
        foreground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foreground)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            particles.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            particles.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            particles.topAnchor.constraint(equalTo: view.topAnchor),
            particles.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            foreground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            foreground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            foreground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            foreground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    class GradientView: UIView {
        override class var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        var startColor: UIColor = UIColor.white
        var endColor: UIColor = UIColor.white
        
        override func layoutSubviews() {
            (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    class ParticleView: UIView {
        var particleImage: UIImage?
        
        override class var layerClass: AnyClass {
            return CAEmitterLayer.self
        }
        func makeEmitterCell(color: UIColor, velocity: CGFloat, scale: CGFloat) -> CAEmitterCell {
            let cell = CAEmitterCell()
            cell.birthRate = 2
            cell.lifetime = 20.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = velocity
            cell.velocityRange = velocity / 4
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 8
            cell.scale = scale
            cell.scaleRange = scale / 4

            cell.contents = particleImage?.cgImage
            return cell
        }
        override func layoutSubviews() {
            let emitter = self.layer as! CAEmitterLayer

            emitter.emitterShape = .line
            emitter.emitterPosition = CGPoint(x: bounds.midX, y: 0)
            emitter.emitterSize = CGSize(width: bounds.size.width, height: 1)

            let near = makeEmitterCell(color: UIColor(white: 1, alpha: 1), velocity: 100, scale: 0.3)
            let middle = makeEmitterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 80, scale: 0.2)
            let far = makeEmitterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 60, scale: 0.1)

            emitter.emitterCells = [near, middle, far]
        }
    }
    class ShapeView: UIView {
        var strokeWidth: CGFloat = 2.0
        var strokeColor: UIColor = UIColor.black
        var fillColor: UIColor = UIColor.clear
        var path: UIBezierPath?

        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
        override func layoutSubviews() {
           let layer = self.layer as! CAShapeLayer

           // take a copy of our original path, because we're about to stretch it
           guard let pathCopy = path?.copy() as? UIBezierPath else { return }

           // create a transform that stretches the path by our width and height, and apply it to the copy
           pathCopy.apply(CGAffineTransform(scaleX: bounds.width, y: bounds.height))

           // apply all our properties to the shape layer
           layer.strokeColor = strokeColor.cgColor
           layer.fillColor = fillColor.cgColor
           layer.lineWidth = strokeWidth
           layer.shadowColor = strokeColor.cgColor
           layer.shadowRadius = 5
           layer.shadowOffset = .zero
           layer.shadowOpacity = 1

           // convert the UIBezierPath to a CGPath and use it for the shape path
           layer.path = pathCopy.cgPath
       }
    }
    func makeForeGround() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0.77))
        bezierPath.addLine(to: CGPoint(x: 0, y: 1.0))
        bezierPath.addLine(to: CGPoint(x: 1.0, y: 1.0))
        bezierPath.addLine(to: CGPoint(x: 1.0, y: 0.08))
        bezierPath.addCurve(to: CGPoint(x: 0.80, y: 0.08), controlPoint1: CGPoint(x: 1.0, y: 0.08), controlPoint2: CGPoint(x: 0.91, y: 0.02))
        bezierPath.addCurve(to: CGPoint(x: 0.55, y: 0.02), controlPoint1: CGPoint(x: 0.69, y: 0.13), controlPoint2: CGPoint(x: 0.56, y: 0.02))
        bezierPath.addCurve(to: CGPoint(x: 0.34, y: 0.02), controlPoint1: CGPoint(x: 0.54, y: 0.02), controlPoint2: CGPoint(x: 0.44, y: -0.03))
        bezierPath.addCurve(to: CGPoint(x: 0.112, y: 0.024), controlPoint1: CGPoint(x: 0.25, y: 0.08), controlPoint2: CGPoint(x: 0.20, y: -0.03))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 0.08), controlPoint1: CGPoint(x: 0.02, y: 0.08), controlPoint2: CGPoint(x: 0, y: 0.08))

        return bezierPath
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}



