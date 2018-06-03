//
//  Extensions.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 21/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    var positionInScene: CGPoint? {
        
        if let scene = scene, let parent = parent {
            return parent.convert(position, to: scene)
            
        } else {
            return nil
        }
    }
    
}

extension SKSpriteNode {
    
    func addFieldOfView() {
        let startPosition = CGPoint.zero
        
        let trianglePath = CGMutablePath()
        trianglePath.move(to: startPosition)
        trianglePath.addLine(to: CGPoint(x: startPosition.x - 150, y: startPosition.y - 200))
        trianglePath.addLine(to: CGPoint(x: startPosition.x + 150, y: startPosition.y - 200))
        trianglePath.addLine(to: startPosition)
        
        let trianglePhysicsBody = SKPhysicsBody(polygonFrom: trianglePath)
        trianglePhysicsBody.affectedByGravity = false
        
        let triangleShape = SKShapeNode(path: trianglePath)
        triangleShape.name = "fieldOfView"
        triangleShape.fillColor = .red
        triangleShape.alpha = 0.2
        triangleShape.physicsBody?.collisionBitMask = CollisionMaskName.fieldOfVision.rawValue
        
        self.addChild(triangleShape)
    }
    
}
