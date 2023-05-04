//
//  HerbCreator.swift
//  ChatApp
//
//  Created by Станислава on 04.05.2023.
//

import UIKit

class HerbCreator {
    private let emitterLayer = CAEmitterLayer()
    
    init(in view: UIView) {
        emitterLayer.emitterShape = .point
        emitterLayer.emitterSize = CGSize(width: 5, height: 5)
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        emitterLayer.emitterCells = [createEmitterCell()]
        emitterLayer.birthRate = 0
        view.layer.addSublayer(emitterLayer)
    }
    
    private func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "herb")?.cgImage
        cell.birthRate = 2
        cell.lifetime = 1
        cell.velocity = 10
        cell.velocityRange = 100
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.scale = 0.07
        cell.scaleRange = 0.03
        cell.alphaSpeed = -0.2
        return cell
    }
}

extension HerbCreator: HerbCreatorProtocol {
    func start(at location: CGPoint) {
        if location.y < emitterLayer.superlayer?.frame.height ?? 0 - 216 {
            emitterLayer.emitterPosition = location
            emitterLayer.birthRate = 5
        }
    }
    
    func move(to location: CGPoint) {
        if location.y < emitterLayer.superlayer?.frame.height ?? 0 - 216 {
            emitterLayer.emitterPosition = location
        }
    }
    
    func stop() {
        emitterLayer.birthRate = 0
    }
}
