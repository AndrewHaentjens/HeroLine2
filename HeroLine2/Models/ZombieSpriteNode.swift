//
//  ZombieSpriteNode.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 10/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

class ZombieSpriteNode: SKSpriteNode {

    var runSpeed: CGFloat = 150.0
    var health: CGFloat = 75.0
    var damage: CGFloat = 7
    var defense: CGFloat = 0.0
    
    func runToward(_ target: SKSpriteNode?) {
        
        /**
         Stop the bodies from bouncing
         */
        physicsBody?.restitution = 0.0
        
        guard let target = target else {
            return
        }
        
        let targetPosition = target.position
        
        let angle = atan2(position.y - targetPosition.y, position.x - targetPosition.x) + CGFloat(Double.pi)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0.0)
        
        run(rotateAction)
        
        let velocotyX = runSpeed * cos(angle)
        let velocityY = runSpeed * sin(angle)
        
        let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
        physicsBody!.velocity = newVelocity
        
    }
    
    func claw(_ warrior: WarriorSpriteNode?) {
        
        guard let warrior = warrior else {
            return
        }
        
        warrior.health = warrior.health - (damage - (damage * warrior.defense))
    }
}
